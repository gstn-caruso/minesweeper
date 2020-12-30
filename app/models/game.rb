class Game < ApplicationRecord
  has_many :cells, autosave: true

  def self.create_easy
    create_with_level(GameLevel.beginner)
  end

  def self.create_with_level(game_level)
    easy_game = Game.new(started_at: DateTime.now)

    cells = []
    cell_number = 0

    mines = mine_positions(game_level)

    (1..game_level.rows).each do |row|
      (1..game_level.columns).each do |column|
        cell_number += 1
        has_mine = mines.include?(cell_number)

        cells << Cell.new(column: column, row: row, has_mine: has_mine)
      end
    end

    easy_game.cells = cells
    easy_game.save!
    easy_game
  end

  private_class_method :create_with_level

  def self.mine_positions(game_level)
    (1..game_level.cells).to_a.sample(game_level.mines)
  end

  private_class_method :mine_positions

  def mines
    cells.where(has_mine: true)
  end

end
