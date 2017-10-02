require 'spec_helper'

describe Cell do 

    describe 'cell neighbors' do
        before do 
            @game = Game.new([[1,1,1],[1,1,1], [1,1,1]])     
        end 

        context 'when the cell is at the left edge of the grid' do 
            before do 
                @cell = @game.cell_at(0, 1)
            end 

            it 'returns 5 neighbors overall' do
                expect(@cell.neighbors.length).to eq 5
            end

            it 'returns 5 live neighbors' do 
                expect(@cell.alive_neighbors.length).to eq 5
            end

            it 'returns 0 dead neighbors' do 
                expect(@cell.dead_neighbors.length).to eq 0
            end
        end

        context 'when the cell is in the bottom row of the grid' do 
            before do 
                @cell = @game.cell_at(1, 0)
            end

            it 'returns 5 neighbors overall' do 
                expect(@cell.neighbors.length).to eq 5
            end

            it 'returns 5 live neighbors' do 
                expect(@cell.alive_neighbors.length).to eq 5
            end

            it 'returns 0 dead neighbors' do 
                expect(@cell.dead_neighbors.length).to eq 0
            end
        end

        context 'when the cell is at the bottom left corner of the grid' do 
            before do 
                @cell = @game.cell_at(0, 0)
            end

            it 'returns 3 neighbors overall' do 
                expect(@cell.neighbors.length).to eq 3
            end

            it 'returns 3 live neighbors' do 
                expect(@cell.alive_neighbors.length).to eq 3
            end

            it 'returns 0 dead neighbors' do 
                expect(@cell.dead_neighbors.length).to eq 0
            end
        end
    end

    describe 'cell state transitions' do 
        before do 
            random_input = Array.new(4){ Array.new(4) { [1, 0].sample } }
            @game = Game.new(random_input)
        end 

        context 'when a cell is alive' do 
            before do 
                @live_cell = @game.cell_at(2, 1)
                @live_cell.give_life
            end

            context 'and the cell has < 2 live neighbors' do 
                before do 
                    while (@live_cell.alive_neighbors.length > 1) do 
                        @live_cell.alive_neighbors.first.kill
                    end
                    @live_cell.set_next_state
                end 

                it 'becomes dead' do 
                    expect(@live_cell.alive?).to be false
                end
            end

            context 'and the cell has > 3 live neighbors' do 
                before do 
                    while (@live_cell.alive_neighbors.length < 4) do 
                        @live_cell.dead_neighbors.first.give_life
                    end
                    @live_cell.set_next_state
                end 

                it 'becomes dead' do 
                    expect(@live_cell.alive?).to be false
                end
            end

            context 'and the cell has 2 or 3 live neighbors' do 
                before do 
                    while(![2, 3].include? @live_cell.alive_neighbors.length) do 
                        if @live_cell.alive_neighbors.length < 2
                            @live_cell.dead_neighbors.first.give_life
                        else
                            @live_cell.alive_neighbors.first.kill
                        end
                    end
                    @live_cell.set_next_state
                end 

                it 'stays alive' do 
                    expect(@live_cell.alive?).to be true
                end
            end
        end

        context 'when a cell is dead' do 
            before do 
                @dead_cell = @game.cell_at(2, 1)
                @dead_cell.kill
            end

            context 'and the cell has exactly 3 live neighbors' do 
                before do 
                    while(!(@dead_cell.alive_neighbors.length == 3)) do 
                        if @dead_cell.alive_neighbors.length < 3
                            @dead_cell.dead_neighbors.first.give_life
                        else
                            @dead_cell.alive_neighbors.first.kill
                        end
                    end
                    @dead_cell.set_next_state
                end

                it 'becomes alive' do 
                    expect(@dead_cell.alive?).to be true
                end
            end
        end
    end
end