class Game
    attr_reader :grid

    def initialize(grid, display_strategy=nil)
        validate_input_array(grid)
        @grid = grid_input_to_cells(grid)
        @display_strategy = display_strategy || ::TerminalDisplayStrategy.new(self)
    end

    def display_grid
        @display_strategy.display
    end

    def to_input_format_a
        # Returns a 2D array where each sub-array represents a row of values along the same y axis.
        output = []
        grid.each_with_index do |row, i|
            output << []
            row.each do |cell, j|
                alive_value = cell.alive? ? 1 : 0
                output[i] << alive_value
            end
        end
        output
    end

    def alive_cell_coordinates
        # Returns [x, y] pairs for cells that are alive. This is convenient as input to an external UI.
        output = []
        grid.flat_map{ |cell| (output << cell) if cell.alive? } 
    end

    def play_turn
        alive_cells, dead_cells = [], []
        grid.flatten.each{ |cell| cell.next_state ? (alive_cells << cell) : (dead_cells << cell) }
        alive_cells.each{ |cell| cell.give_life }
        dead_cells.each{ |cell| cell.kill }
    end

    def play_turns(n)
        n.times{ play_turn }
    end

    def play_turns_with_display(n)
        @display_strategy.display_for_turns(n)
    end

    def cell_at(x, y)
        return grid[y][x] if ((x < (width)) && (y < (height)))
        nil
    end

    def height
        grid.length
    end

    def width 
        grid.first.length
    end

    class << self
        def test_game(seed, number_of_iterations, expected_state)
            # This method is implemented as specified in the challenge instructions. 
            game = Game.new(seed)
            game.play_turns(number_of_iterations)
            expected_state == game.to_input_format_a
        end
    end

    private

    def grid_input_to_cells(grid_input)
        cell_output = Array.new(grid_input.length){ [] }
        grid_input.each_with_index do |sub_array, y|
            sub_array.each_with_index do |cell_value, x|
                cell_output[y][x] = Cell.new((cell_value == 1), self, x, y)
            end
        end
        cell_output
    end

    def validate_input_array(input_array)
        raise 'Input must be an Array.' unless input_array.is_a? Array
        raise 'Input must be a non-empty 2D Array.' unless !input_array.empty?

        subarray_lengths = input_array.map{ |sub| sub.length }.uniq.length
        unless subarray_lengths == 1
            raise 'Input must be an Array of Arrays, each of which has length N.'
        end
    end
end