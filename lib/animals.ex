defmodule Animals do
  @moduledoc """
  The `%Animals{}` struct is used to create a binary tree which contains
  animals and questions used to distinguish between them.

  The `query` function is used to walk the tree and uses callbacks to
  get user input along the way to select the path through the tree.

  for each branch in the tree the `query` function will query the user
  if a question from a node in the tree is true or false.  Based on
  the user input, the `select_path` function will choose one path or
  the other from the node.
  
  When a leaf node is reached, the user input determines if the animal
  on that leaf is the the one the user was thinking of or not.

  If the user indicates the animal was correct, the animal is returned
  and as the recursion used to reach that point returns, the tree is
  rebuilt and returned unchanged. (I know how efficient is that?)

  If the user indicates the animal was not correct, a callback is used
  to collect the correct name of the animal the user was thinking of
  and a differentiating question.  This is used to form a new node
  which include the new animal, question and the guessed animal.  This
  replaces the location in the tree where the guessed animal was, and
  the tree is rebuilt as the recursion returns.

  It isn't super efficient to rebuild the tree for each return, but
  unless there are thousands of animals in the database, it works
  without noticeable delay.

  This could be expored in the future to find a more efficient
  approach. This was the first try.
  """

  @derive Jason.Encoder
  defstruct y: nil, n: nil, question: nil

  @type t :: %Animals{
          y: {String.t() | Animals.t()},
          n: {String.t() | Animals.t()},
          question: String.t()
        }

  # The following callbacks must be implemented by another module.
  # This is used to abstract the UI from the game logic.
  
  @callback new_animal(String.t()) :: {String.t(), String.t(), String.t()}
  @callback guess({Animals.t() | String.t()}) :: boolean
  @callback correct_guess(String.t()) :: String.t()
  @callback play_again() :: boolean


  @doc """
  The `decode` function can be used to decode the result of
  `Jason.decode!(data)` and build a `%Animals{}` based binary tree.

  # Example

    iex> decoded = %{ "y" => "bird", "n" => "pig", "question" => "flies" } |> Animals.decoder()
    %Animals{ y: "bird", n: "pig", question: "flies" }
  """
  def decoder(data) when is_binary(data), do: data

  def decoder(data),
    do: %Animals{y: decoder(data["y"]), n: decoder(data["n"]), question: data["question"]}

  @doc """
  The `play` function starts a new game.  The `tree` parameter
  contains the binary tree describing the current animal knowledge
  base.  This tree will be walked recursively using the `query`
  function below.

  The `impl` parameter provides the module which contains the callback
  functions.

  The `play_again` parameter indicates if the a new game should be
  started once the first is completed.  if it is true, the `play`
  function is called recursively until it becomes false.  the value of
  the play_again parameter is determined by the `play_again` callback
  function.
  """
  def play(tree, _, false), do: tree

  def play(tree, impl, true) do
    tree
    |> query(impl)
    |> play(impl, impl.play_again())
  end

  @doc """
  The `query` function uses the `guess` callback to ask the user
  questions based on its location in the tree.  The result of the
  `guess` callback is passed to the `select_path` function which
  chooses a path in the tree and recursively calls the `query`
  function with a new node of the tree.

  The `impl` parameter provides the module which contains the callback
  functions.

  query returns a new tree based on the outcome of the game.
  """
  def query(tree, impl), do: impl.guess(tree) |> select_path(tree, impl)

  @doc """
  The `select_path` function selects the next path in the tree to
  search for a solution.

  The first parameter is the result of the query, this corresponds the
  the `:y` or `:n` node in the binary tree.

  The `tree` parameter is the current binary sub-tree being selected on.

  The `impl` parameter provides the module which contains the callback
  functions.
  """
  # non-leaf actions
  def select_path(true, tree = %Animals{}, impl),
    do: Map.put(tree, :y, query(Map.get(tree, :y), impl))

  def select_path(false, tree = %Animals{}, impl),
    do: Map.put(tree, :n, query(Map.get(tree, :n), impl))

  # leaf actions
  def select_path(true, animal, impl), do: impl.correct_guess(animal)
  def select_path(false, animal, impl), do: impl.new_animal(animal)
end
