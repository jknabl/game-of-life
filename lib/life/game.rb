class Game
    attr_reader :grid
    attr_writer :display_strategy

    def initialize(grid, display_strategy=TerminalDisplayStrategy)
        validate_input_array(grid)
        @grid = grid_input_to_cells(grid)
        @display_strategy = display_strategy.new(self)
    end

    def display_grid
        @display_strategy.display
    end

    def play_turns_with_display(n)
        @display_strategy.display_for_turns(n)
    end

    def to_input_format_a
        # Returns a 2D array where each sub-array represents a row of values along the same y axis.
        # output = []
        grid.collect.with_index do |row, i|
            row.collect{ |cell| cell.alive? ? 1 : 0 }
        end
    end

    def to_input_format_for_iterations_a(n)
        (n+1).times.inject({}) do |accum, i|
            play_turn unless i == 0
            accum[i] = to_input_format_a
            accum
        end
    end

    def alive_cell_coordinates
        # Returns [x, y] pairs for cells that are alive. This is convenient as input to an external UI.
        grid.flatten.collect{ |cell| cell.to_coordinates if cell.alive? }
    end

    def play_turn
        # Why not just iterate over each cell and kill/give life as encountered? Because modifying a 
        # cell's alive value will affect how other cells calculate their own alive values. We need 
        # to calculate aliveness based on a static snapshot of the board. So we have to collect and
        # then operate in bulk. 
        alive_cells, dead_cells = [], []
        grid.flatten.each{ |cell| cell.next_state ? (alive_cells << cell) : (dead_cells << cell) }
        alive_cells.each{ |cell| cell.give_life }
        dead_cells.each{ |cell| cell.kill }
    end

    def play_turns(n)
        n.times{ play_turn }
    end

    def cell_at(x, y)
        return nil if (x < 0 || y < 0 || (x > (width - 1)) || (y > (height - 1)))
        grid[(height - 1) - y][x] 
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
        y_axis_size = grid_input.length - 1
        grid_input.each_with_index do |sub_array, y_pos|
            sub_array.each_with_index do |cell_value, x_pos|
                cell_output[y_pos][x_pos] = Cell.new((cell_value == 1), self, x_pos, (y_axis_size -  y_pos))
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