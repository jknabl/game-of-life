class Cell
    attr_reader :x, :y, :game

    def initialize(alive=false, game, x, y)
        @x = x
        @y = y
        @game = game
        @alive = alive
    end

    def alive? 
        @alive
    end

    def dead?
        !@alive
    end

    def give_life
        @alive = true
    end

    def kill
        @alive = false
    end
    
    def neighbors
        n = [
            @game.cell_at((x + 1), y), 
            @game.cell_at(x, (y+1)), 
            @game.cell_at((x+1), (y+1))
        ]
        n << edge_and_corner_neighbors
        n.flatten.compact
    end

    def alive_neighbors
        neighbors.select{ |cell| cell.alive? }
    end

    def dead_neighbors
        neighbors - alive_neighbors
    end

    def next_state
        return false if (underpopulated? || overpopulated?)
        return true if (reproductive? || healthy?)
        @alive
    end

    def set_next_state
        @alive = next_state
    end

    def to_coordinates
        [x, y]
    end

    private 

    def underpopulated?
        alive? && (alive_neighbors.length < 2)
    end

    def overpopulated?
        alive? && (alive_neighbors.length > 3)
    end

    def reproductive?
        dead? && (alive_neighbors.length == 3)
    end

    def healthy?
        alive? && ([2,3].include? alive_neighbors.length)
    end

    def left_column_neighbors
        if on_left_edge_of_grid? 
            []
        else
            [
                @game.cell_at((x-1), y),
                @game.cell_at((x-1), (y+1))
            ].compact
        end
    end

    def bottom_row_neighbors
        if on_bottom_edge_of_grid?
            []
        else
            [
                @game.cell_at(x, (y-1)), 
                @game.cell_at(x+1, (y-1))
            ].compact
        end
    end

    def bottom_left_corner_neighbor
        ((on_left_edge_of_grid? || on_bottom_edge_of_grid?)) ? [] : [@game.cell_at((x-1), (y-1))]
    end

    def edge_and_corner_neighbors
        left_column_neighbors + bottom_row_neighbors + bottom_left_corner_neighbor
    end

    def on_left_edge_of_grid?
        x == 0
    end

    def on_bottom_edge_of_grid?
        y == 0
    end
end