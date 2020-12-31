class Game < ApplicationRecord
  has_many :cells, autosave: true

  def self.create_easy
    game_level = GameLevel.beginner
    create_with_level(game_level, mine_positions(game_level))
  end

  def self.create_with_level(game_level, mine_positions)
    easy_game = Game.new(started_at: DateTime.now,
                         columns: game_level.columns,
                         rows: game_level.rows,
                         mines: game_level.mines)

    cells = []
    cell_number = 0

    (1..game_level.rows).each do |row|
      (1..game_level.columns).each do |column|
        cell_number += 1
        has_mine = mine_positions.include?(cell_number)

        cells << Cell.new(column: column, row: row, has_mine: has_mine)
      end
    end

    easy_game.cells = cells
    easy_game.save!
    easy_game
  end

  def self.mine_positions(game_level)
    (1..game_level.cells).to_a.sample(game_level.mines)
  end

  private_class_method :mine_positions

  def reveal(column, row)
    cell_to_reveal = cells.find_by!(column: column, row: row)
    cell_to_reveal.reveal
    cells.map(&:reveal)
  rescue ActiveRecord::RecordNotFound
    raise "cell (#{column},#{row}) does not exist"
  end

  def loosed?
    mines.any?(&:revealed?)
  end

  def mines
    cells.where(has_mine: true)
  end

end
