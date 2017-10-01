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
end