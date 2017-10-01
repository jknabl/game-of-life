class TerminalDisplayStrategy
    def initialize(game)
        @game = game
        @grid = game.grid
    end

    def display
        puts `clear`
        val = @grid.map{ |row| row.map{ |cell| cell.alive? ? 'o' : '.' }.join('') }
        val.each{ |v| puts "#{v}\n" }
    end

    def display_for_turns(n)
        display_and_sleep
        n.times do 
            @game.play_turn
            display_and_sleep
        end
    end

    private

    def display_and_sleep
        display
        sleep 0.5
    end
end