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
end