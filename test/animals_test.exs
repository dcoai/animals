defmodule AnimalsTest do
  use ExUnit.Case
  doctest Animals


  test "json encoder" do
    encoded = %Animals{ y: "abc", n: "def", question: "qqq" } |> Jason.encode!()
    assert encoded == "{\"n\":\"def\",\"question\":\"qqq\",\"y\":\"abc\"}"
  end
  
  test "json decoder" do
    decoded = %{ "y" => "abc", "n" => "def", "question" => "qqq" } |> Animals.decoder()
    assert decoded == %Animals{ y: "abc", n: "def", question: "qqq" }
  end

  test "query - behavior scenario 0 - correctly guess owl" do
    result = Animals.query(Animals.BehaviorScenario0.setup, Animals.BehaviorScenario0)
    assert Animals.BehaviorScenario0.setup() == result
  end

  test "query - behavior scenario 1" do
    result = Animals.query(Animals.BehaviorScenario1.setup() |> IO.inspect, Animals.BehaviorScenario1) |> IO.inspect
    assert Animals.BehaviorScenario1.result() == result
  end
  
end


# test
defmodule Animals.BehaviorScenario0 do
  @behaviour Animals
  @debug false

  def log_debug(str), do: if @debug, do: IO.puts(str)
  
  @impl Animals
  def new_animal(_), do: %Animals{}
  
  @impl Animals
  def guess(animal) when is_binary(animal) do
    log_debug("guess(#{animal}) ->  true")
    true
  end

  def guess(tree = %Animals{}) do
    log_debug("guess(#{tree |> inspect()}) question:'#{tree.question}' -> true")
    true
  end

  @impl Animals
  def correct_guess(animal) do
    log_debug("correctly guessed #{animal}")
    animal
  end

  @impl Animals
  def play_again() do
    log_debug("request play again -> false")
    false
  end

  def setup() do
    log_debug("#{__MODULE__} -- setup()")
    %Animals{ y: "owl", n: "toad", question: "flies" }
  end
end

defmodule Animals.BehaviorScenario1 do
  @behaviour Animals
  @debug true

  def log_debug(str), do: if @debug, do: IO.puts(str)
  
  @impl Animals
  def new_animal(orig_animal) do
    new_animal = %Animals{y: "frog", n: orig_animal, question: "has smooth skin"}
    log_debug("new_animal frog - orig_animal:#{orig_animal} --> #{new_animal |> inspect()}")
    new_animal
  end    
  
  @impl Animals
  def guess(animal) when is_binary(animal) do
    log_debug("guess(#{animal}) -> false")
    false
  end

  def guess(tree = %Animals{}) do
    log_debug("guess(#{tree |> inspect()}) question:'#{tree.question}' -> false")
    false
  end

  @impl Animals
  def correct_guess(animal) do
    log_debug("correctly guessed #{animal}")
    animal
  end

  @impl Animals
  def play_again() do
    log_debug("request play again -> false")
    false
  end

  def setup() do
    log_debug("#{__MODULE__} -- setup()")
    %Animals{ y: "owl", n: "toad", question: "flies" }
  end

  def result() do
    %Animals{ y: "owl", n: %Animals{y: "frog", n: "toad", question: "has smooth skin"}, question: "flies" }
  end
end
