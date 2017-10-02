class FileDisplayStrategy < DisplayStrategy    
    def display
        write_to_file do |f|
            produce_lines.each{ |row| f << row }
        end
    end

    def display_for_turns(n)
        write_to_file do |f|
            n.times do |i|
                f << "Iteration #{i+1}:\n\n"
                produce_lines.each{ |line| f << line }
                f << "\n---\n"
                @game.play_turn
            end
        end
    end

    private

    def produce_lines
        lines = (@grid.map{ |row| row.map{ |cell| cell.alive? ? 'o' : '.' }.join('') << "\n"})
    end

    def write_to_file
        File.open('game_of_life_output.txt', 'w') do |f|
            yield(f)
        end
    end
end