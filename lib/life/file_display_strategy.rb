class FileDisplayStrategy < DisplayStrategy    
  def display
    write_to_file do |f|
      produce_lines.each{ |row| f << row }
    end
  end

  def display_for_turns(n)
    write_to_file do |f|
      (n+1).times do |i|
        f << "Iteration #{i}:\n\n"
        produce_lines.each{ |line| f << line }
        @game.play_turn
        f << "\n---\n"
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