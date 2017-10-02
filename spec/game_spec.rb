require 'spec_helper'

describe Game do   
  context 'when given something other than an Array as input' do 
    it 'is invalid' do 
      expect{ Game.new("hello world!") }.to raise_exception 'Input must be an Array.'
    end
  end

  context 'when given a blank array as input' do 
    it 'is invalid' do 
      expect{ Game.new([]) }.to raise_exception 'Input must be a non-empty 2D Array.'
    end
  end

  context 'when given an input array with inconsistent subarray lengths' do 
    it 'is is invalid' do 
      expect{ Game.new([[1,0], [1], [1,0]])}.to raise_exception 'Input must be an Array of Arrays, each of which has length N.'
    end
  end

  it 'initializes a Game given a 2D array of 1s and 0s' do 
    g = Game.new([[1,0], [0,1]])
    expect(g.grid[0][0].is_a? Cell).to be true
    expect(g.grid[0][0].alive?).to be true
  end

  describe 'full board state switching across turns' do 
    describe 'a symmetric alternating pattern' do 
      before do 
        # This game pattern will toggle between a horizontal and vertical line in the middle 
        # indefinitely. 
        @game = Game.new([[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]])
      end

      describe 'orientation of the middle row of alive cells' do 
        it 'ends in horizontal state after an even number of iterations' do 
          (1..10).each do |i|
            @game.play_turn
            if (i % 2) == 0
              expect(@game.cell_at(2,1).alive?).to be false
              expect(@game.cell_at(2,3).alive?).to be false

              expect(@game.cell_at(1,2).alive?).to be true
              expect(@game.cell_at(2,2).alive?).to be true
              expect(@game.cell_at(3,2).alive?).to be true
            end
          end
        end

        it 'ends in vertical state after an odd number of iterations' do 
          (1..10).each do |i| 
            @game.play_turn
            unless (i % 2) == 0
              expect(@game.cell_at(1,2).alive?).to be false
              expect(@game.cell_at(3,2).alive?).to be false

              expect(@game.cell_at(2,1).alive?).to be true
              expect(@game.cell_at(2,2).alive?).to be true
              expect(@game.cell_at(2,3).alive?).to be true
            end
          end
        end
      end
    end

    describe 'an asymmetric terminating pattern' do 
      before do 
        @game = Game.new([ [0,1,0], [1,0,0], [1,0,0]])
      end

      it 'matches expected state after 1 iteration' do 
        @game.play_turn
        expect(@game.cell_at(0,1).alive?).to be true
        expect(@game.cell_at(1,1).alive?).to be true
      end

      it 'leaves a blank board after 2 iterations' do 
        @game.play_turns(2)
        expect(@game.grid.flatten.select{ |cell| cell.alive? }.length).to eq 0
      end
    end

    describe 'an asymmetric pattern that terminates after 5 iterations' do 
      before do 
        @game = Game.new([ [0,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,1,1,0], [0,0,0,0,0,0] ])
      end

      it 'matches expected state after 1 turn' do 
        expect(Game.test_game(
          [ [0,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,1,1,0], [0,0,0,0,0,0] ], 
          1, 
          [ [0,0,0,0,0,0], [0,0,1,1,0,0], [0,0,1,1,0,0], [0,0,0,1,0,0] ]
        )).to be true
      end

      it 'matches expected state after 2 turns' do 
        expect(Game.test_game(
          [ [0,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,1,1,0], [0,0,0,0,0,0] ],
          2, 
          [ [0,0,0,0,0,0], [0,0,1,1,0,0], [0,0,0,0,1,0], [0,0,1,1,0,0] ]
        )).to be true
      end

      it 'matches the expected state after 3 turns' do 
        expect(Game.test_game(
          [ [0,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,1,1,0], [0,0,0,0,0,0] ], 
          3, 
          [ [0,0,0,0,0,0], [0,0,0,1,0,0], [0,0,0,0,1,0], [0,0,0,1,0,0] ]
        )).to be true
      end

      it 'matches the expected state after 4 turns' do 
      expect(Game.test_game(
          [ [0,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,1,1,0], [0,0,0,0,0,0] ], 
          4, 
          [ [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,1,1,0], [0,0,0,0,0,0] ]
        )).to be true
      end

      it 'has an empty grid after 5 turns' do 
        expect(Game.test_game(
          [ [0,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,1,1,0], [0,0,0,0,0,0] ], 
          5, 
          [ [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0] ]
        ))
      end
    end
  end

  describe '#to_input_format_for_iterations_a(n)' do 
    before do 
      @game = Game.new([ [0,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,1,1,0], [0,0,0,0,0,0] ])
    end

    it 'matches the expected state after 3 turns' do 
      expect(@game.to_input_format_for_iterations_a(3)).to eq ({ 
      0 => [ [0,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,1,1,0], [0,0,0,0,0,0] ], 
      1 => [ [0,0,0,0,0,0], [0,0,1,1,0,0], [0,0,1,1,0,0], [0,0,0,1,0,0] ], 
      2 => [ [0,0,0,0,0,0], [0,0,1,1,0,0], [0,0,0,0,1,0], [0,0,1,1,0,0] ], 
      3 => [ [0,0,0,0,0,0], [0,0,0,1,0,0], [0,0,0,0,1,0], [0,0,0,1,0,0] ] 
      })
    end
  end

  describe 'Game.test_game' do 
    # NOTE: in these specs, we use the same seed array as in the group above. The initial 
    # state is a horizontal line in the middle of the board. With each iteration, the line 
    # switches orientation such that on odd turns it is vertical and on even turns it is 
    # horizontal.
    before do 
      @even_state = [[0,0,0,0,0], [0,0,0,0,0], [0,1,1,1,0], [0,0,0,0,0], [0,0,0,0,0]]
      @odd_state = [[0,0,0,0,0], [0,0,1,0,0], [0,0,1,0,0], [0,0,1,0,0], [0,0,0,0,0]]
    end

    it 'does not match seed state after 1 iteration' do 
      expect(Game.test_game(@even_state, 1, @even_state)).to be false
    end

    it 'matches seed state after 2 iterations' do 
      expect(Game.test_game(@even_state, 2, @even_state)).to be true
    end

    it 'does not match seed state after 3 iterations' do 
      expect(Game.test_game(@even_state, 3, @even_state)).to be false
    end

    it 'matches seed state after 4 iterations' do 
      expect(Game.test_game(@even_state, 4, @even_state)).to be true
    end
  end

  describe '#alive_cell_coordinates' do 
    before do 
      @game = Game.new([[0,1,0], [1,0,1], [0,1,1]])
    end

    it 'returns coordinates of all live cells as [x,y] pairs' do 
      expect(@game.alive_cell_coordinates).to include(*[ [1,2], [0,1], [2,1], [1,0], [2,0] ])
    end

    it 'does not include co-ordinates of dead cells' do 
      expect(@game.alive_cell_coordinates).to_not include( *@game.grid.flatten.
      select{ |cell| cell.dead? ? cell.to_coordinates : nil}.compact )
    end
  end
end