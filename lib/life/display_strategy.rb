class DisplayStrategy
  def initialize(game)
    @game = game
    @grid = @game.grid
  end

  def display
    raise 'Subclasses of DisplayStrategy must implement a #display instance method.'
  end
end