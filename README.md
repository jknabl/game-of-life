# Conway's Game of Life

## Description and Rules of the Game

This is a gemified version of Conway's Game of Life. The game is a zero-player game, meaning you simply start it and watch it go. 

The game consists of a number of cells situated on an NxM grid. A cell must be in one of two states: alive or dead. On each turn, cells transition between alive and dead states according to the following rules: 

* Any live cell with fewer than two live neighbours dies, as if caused by under­population.
* Any live cell with two or three live neighbours lives on to the next generation.
* Any live cell with more than three live neighbours dies, as if by over­population.
* Any dead cell with exactly three live neighbours becomes a live cell, as if by
reproduction.

## Structure of the code

The code is structured according to rubygems conventions. Most of the interesting stuff -- including the `Game`, `Cell`, and display classes -- is in `lib/life`. There is also a test script located outside the lib directory, at `bin/test`. Instructions on testing are below.

Tests for the main classes and all important functionality are located under `spec/`. 

### Why a gem? 

Bundling up this program as a gem makes it much easier to distribute and share. Building and installing a gem is less hassle for a user than running a patchwork of custom scripts. 

Importantly, it is extremely easy to drop this gem into e.g. a Rails project. A simple `require 'game-of-life', github: 'https://github.com/jknabl/game-of-life.git'` in the `Gemfile` does the trick. Then we can rely on the core logic in the gem to handle all of the 'business logic' and avoid having to re-write code. 

## Installing the downloaded gem

This gem was developed and tested in a UNIX-like environment, using ruby 2.3.1. You will need a working ruby installed in order to follow the steps below.s

To install on e.g. MacOSX or Linux, do:

```
1. cd path/to/life
2. gem build life.gemspec
3. gem install ./game-of-life-0.1.0.gem
```
### Verifying installation

Once installed, you will be able to access game functionality from a ruby console: 

```
> irb 
> require 'life'
=> true

> game = Game.new([[1,0],[0,0]])
=> #<Game:0x007fc684a68ba8 @grid=[[#<Cell:0x007fc684a689a0 @x=0, @y=1, @game=#<Game:0x007fc684a68ba8 ...>, @alive=true>, #<Cell:0x007fc684a68950 @x=1, @y=1, @game=#<Game:0x007fc684a68ba8 ...>, @alive=false>], [#<Cell:0x007fc684a688b0 @x=0, @y=0, @game=#<Game:0x007fc684a68ba8 ...>, @alive=false>, #<Cell:0x007fc684a68838 @x=1, @y=0, @game=#<Game:0x007fc684a68ba8 ...>, @alive=false>]], @display_strategy=#<TerminalDisplayStrategy:0x007fc684a687e8 @game=#<Game:0x007fc684a68ba8 ...>, @grid=[[#<Cell:0x007fc684a689a0 @x=0, @y=1, @game=#<Game:0x007fc684a68ba8 ...>, @alive=true>, #<Cell:0x007fc684a68950 @x=1, @y=1, @game=#<Game:0x007fc684a68ba8 ...>, @alive=false>], [#<Cell:0x007fc684a688b0 @x=0, @y=0, @game=#<Game:0x007fc684a68ba8 ...>, @alive=false>, #<Cell:0x007fc684a68838 @x=1, @y=0, @game=#<Game:0x007fc684a68ba8 ...>, @alive=false>]]>>

> game.display_grid

o.
..

> Game.test_game([[1,0], [0,0]], 1, [[1,0], [0,0]])
=> false
```

### Testing without a ruby console

The gem includes a command-line script for testing the `Game.test_game` method. Use this method to test easily without having to navigate an irb console. 

The script is located at `./bin/test`; it takes three arguments: 

* *-s*: a string representing the starting array (e.g. `-s "[[1,0],[0,1]]"`)
* *-n*: an integer representing the number of times to run the game (e.g. `-n 4`)
* *-e*: a string representing an array representation of the expected end state of the game (e.g. `-e "[[1,0],[0,1]]"`) 

The format for both the seed and expected result arrays is: each inner array represents a row on the game grid. Rows should be ordered as though you were looking at the game board with the top row *first* (i.e., descending by y-axis value). For example, `[[1,0],[0,1]]` corresponds to: 

```
1,0
0,1
``` 

The script prints `true` to the console if the starting array matches the expected output at the end of N iterations; it returns `false` otherwise.

Here is an example of running the script: 

```
> ruby bin/test -s "[[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]]" -n 4 -e "[[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,1]]"
false
```

...and another: 

```
>ruby bin/test -s "[[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]]" -n 4 -e "[[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]]"
true
```

### Installing from github and including in a project

You can install the gem from github and include it in a project you are working on. This saves you the hassle of having to do a local install. 

Simply add the following to your `Gemfile`: 

gem 'game-of-life', git: 'https://github.com/jknabl/game-of-life.git', require: 'life'

## Public interface

There are just a few main methods you will need to use in order to test the gem. The examples below all assume that you have installed the gem as outlined above.

### Testing for equality of expected output

The `Game` class provides a class method that allows you to specify a start state, number of iterations, and expected end state. The method returns true if the start state transforms into the expected end state after N iterations. For example: 

```
> ruby bin/test -s "[[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]]" -n 4 -e "[[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,1]]"
false

>ruby bin/test -s "[[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]]" -n 4 -e "[[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]]"
true
```

### Running a simulation within irb

Within irb, you can run a simulation by instantiating a `Game` and calling `#play_turn` or `#play_turns(n)`. You can also run a simulation with any number of iterations and view the sequence of results by using `#play_turns_with_display(n)`. 

To play a single turn and view the result, do: 

```
$ irb
require 'life'
game = Game.new([[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]])
game.display_grid

.....
.....
.ooo.
.....
.....

game.play_turn

.....
..o..
..o..
..o..
.....
```

To play multiple turns and view the result, do: 


```
$ irb 
require 'life'
game = Game.new([[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]])
game.display_grid

.....
.....
.ooo.
.....
.....

game.play_turns(3)
game.display_grid

.....
..o..
..o..
..o..
.....
```

To skip a couple steps and display an animated sequence of transitions as they happen, do: 

```
$ irb
require 'life'
game = Game.new([[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]])
game.play_turns_with_display(3)

.....
.....
.ooo.
.....
.....

.....
..o..
..o..
..o..
.....

.....
.....
.ooo.
.....
.....

.....
..o..
..o..
..o..
.....
```

### Choosing a display strategy

This implementation associates a 'display strategy' with each game instance. A display strategy is a unique implementation of outputting the results of a simulation. 

There are two display strategies implemented out of the box: 

* `TerminalDisplayStrategy`: prints output as text in sequence to the console. 
* `FileDisplayStrategy`: prints output as a chronological log to a text file (default file is `game_of_life_output.txt` in the directory from which you ran irb/the script). 

Here is an example of the default `TerminalDisplayStrategy`, which outputs to console: 

```
irb
require 'life'
game = Game.new([[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]])
game.display_grid

.....
.....
.ooo.
.....
.....
```

Here is an example of creating a game with the `FileDisplayStrategy`: 

```
$pwd 
/Users/jknabl/Documents/code-projects/life

irb
require 'life'
game = Game.new([[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]], FileDisplayStrategy)
game.play_turns_with_display(3)
exit

$ pwd
/path/to/life

$ cat /path/to/life/game_of_life_output.txt
Iteration 0:

.....
.....
.ooo.
.....
.....

---
Iteration 1:

.....
..o..
..o..
..o..
.....

---
Iteration 2:

.....
.....
.ooo.
.....
.....

---
Iteration 3:

.....
..o..
..o..
..o..
.....

--
```