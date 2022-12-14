defmodule Animals.CLI do
  @behaviour Animals

  @moduledoc """
  Animals CLI main
  """

  @state_file "~/.animals"

  def main(_args) do
    welcome()

    load()
    |> Animals.play(__MODULE__, true)
    |> save()

    IO.puts("Ok, see you later!")
  end

  def welcome do
    IO.puts("Welcome to the animal guessing game!\n")
    IO.puts("Think of an animal...\n")
    Enquirer.get("Press [Return] when you have thought of one.")
  end

  def select_answer({:ok, ans}), do: ans

  def article(animal) do
    case animal |> String.starts_with?(["a", "e", "i", "o", "u"]) do
      true -> "an #{animal}"
      false -> "a #{animal}"
    end
  end

  @impl Animals
  def new_animal(orig_animal) do
    animal = Enquirer.get("What is the name of your animal?") |> select_answer

    txt =
      "What is a yes/no question to tell the difference between #{animal |> article()} and #{orig_animal |> article()}?"

    question = Enquirer.get(txt) |> select_answer

    case Enquirer.ask("is the question true for #{animal |> article}") |> select_answer do
      true -> %Animals{y: animal, n: orig_animal, question: question}
      false -> %Animals{y: orig_animal, n: animal, question: question}
    end
  end

  @impl Animals
  def guess(animal) when is_binary(animal),
    do: Enquirer.ask("is it #{animal |> article}?") |> select_answer

  def guess(tree = %Animals{}), do: Enquirer.ask("#{tree.question}?") |> select_answer

  @impl Animals
  def correct_guess(animal) do
    IO.puts("I knew it was #{animal |> article}")
    animal
  end

  @impl Animals
  def play_again(), do: Enquirer.ask("\n\nPlay again?") |> select_answer

  def save(tree = %Animals{}) do
    Path.expand(@state_file)
    |> File.write!(Jason.encode!(tree, pretty: true))

    tree
  end

  def load() do
    try do
      Path.expand(@state_file)
      |> File.read!()
      |> Jason.decode!()
      |> Animals.decoder()
    rescue
      File.Error -> %Animals{y: "dog", n: "fish", question: "does it have four legs"}
    end
  end
end
