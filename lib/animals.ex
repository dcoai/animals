defmodule Animals do
  @moduledoc """
  Documentation for `Animals`.
  """

  @derive Jason.Encoder
  defstruct y: nil, n: nil, question: nil

  @type t :: %Animals{
          y: {String.t() | Animals.t()},
          n: {String.t() | Animals.t()},
          question: String.t()
        }

  def decoder(data) when is_binary(data), do: data

  def decoder(data),
    do: %Animals{y: decoder(data["y"]), n: decoder(data["n"]), question: data["question"]}

  @callback new_animal(String.t()) :: {String.t(), String.t(), String.t()}
  @callback guess({Animals.t() | String.t()}) :: boolean
  @callback correct_guess(String.t()) :: String.t()
  @callback play_again() :: boolean

  def play(tree, _, false), do: tree

  def play(tree, impl, true) do
    tree
    |> query(impl)
    |> play(impl, impl.play_again())
  end

  def query(tree, impl), do: impl.guess(tree) |> select_path(tree, impl)

  def select_path(true, tree = %Animals{}, impl),
    do: Map.put(tree, :y, query(Map.get(tree, :y), impl))

  def select_path(false, tree = %Animals{}, impl),
    do: Map.put(tree, :n, query(Map.get(tree, :n), impl))

  def select_path(true, animal, impl), do: impl.correct_guess(animal)
  def select_path(false, animal, impl), do: impl.new_animal(animal)
end
