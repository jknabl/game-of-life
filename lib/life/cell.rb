class Cell
  attr_reader :x, :y, :game

  def initialize(alive=false, game, x, yg)
    @x = x
    @y = yg
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
      @game.cell_at((x-1), (y-1)), 
      @game.cell_at((x-1), y), 
      @game.cell_at((x-1), (y+1)), 
      @game.cell_at(x, (y-1)), 
      @game.cell_at(x, (y+1)), 
      @game.cell_at((x+1), (y-1)), 
      @game.cell_at((x+1), y), 
      @game.cell_at((x+1), (y+1))
    ]
    n.compact
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
end