require 'spec_helper'

describe Game do     
    it 'initializes a Game given a 2D array of 1s and 0s' do 
        g = Game.new([[1,0], [0,1]])
        expect(g.grid[0][0].is_a? Cell).to be true
        expect(g.grid[0][0].alive?).to be true
    end
end