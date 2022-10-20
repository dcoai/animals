# Animals

An elixir implementation of the animals guessing game.

The animals game works as follows: the computer asks questions to try
to guess an animal you are thinking about.  Eventually it will ask for
example, "is your animal a dog?".  If it can't guess your animal, it
asks for the name of the animal as well as a question which it can use
to differentiate between other animals.  It saves it's animal data in
`~/.animals` so it will continue to "learn" about more animals from
one play to another.

I have no idea who originally wrote this, it goes back at least to the
80's, I suspect earlier.  If anyone knows, and can provide a reference
with some better support than, "it was me," let me know and point me
to references.

## Install

[Install Elixir](https://elixir-lang.org/install.html)

build the project with:

```
mix deps.get
mix test
mix escript.build
```

At this point, you can copy the `animals` executable to any directory
in your path, or just run in place.

```
sudo cp animals /usr/local/bin
chmod 755 /usr/local/bin/animals
```

## Run

run the program:

```
$ animals
```

or if running `animals` from your current directory use:

```
$ ./animals
```

## The Code

The logic for the game is contained in the `Animals` module.  The
module also defines the %Animals{} struct, and an encode/decoder for
the Jason module (used to serialize the data and store/load it).

The logic for the game itself is simple it is contained in the last 15
or so lines of code at the bottom of the module.  The %Animals{}
struct is used to arrange the date in a binary tree which is module
walks to guess an animal.

There are 4 callbacks used to abstract the UI from the games logic.

The `Animals.CLI` module contains the escript main function, the
callbacks for the Animals module, the load/save functions to save
state between runs.

## ToDO

It may be wishful thinking, but at some point, I may make a liveview
front end for the game.
