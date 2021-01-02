class GameLevel
  attr_reader :cells, :rows, :columns, :mines

  def initialize(rows, columns, mines)
    @mines = mines
    @rows = rows
    @columns = columns
    @cells = rows * columns
  end

  def self.beginner
    new(9, 9, 10)
  end

  def mine_positions
    (1..cells).to_a.sample(mines)
  end
end
