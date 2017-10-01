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
end