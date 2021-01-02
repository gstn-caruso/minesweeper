class Game < ApplicationRecord
  has_many :cells, autosave: true

  def self.create_easy
    game_level = GameLevel.beginner
    create_with_level(game_level, game_level.mine_positions)
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

        cells << Cell.new(cell_column: column, row: row, has_mine: has_mine)
      end
    end

    cells.each do |cell|
      cell.surrounding_mines = surrounding_mines(cell, cells)
    end

    easy_game.cells = cells
    easy_game.save!
    easy_game
  end

  def self.surrounding_mines(a_cell, cells)
    surrounding_cell_rows = (a_cell.row - 1..a_cell.row + 1)
    surrounding_cell_columns = (a_cell.cell_column - 1..a_cell.cell_column + 1)

    cells.count do |cell|
      surrounding_cell_rows.include?(cell.row) && surrounding_cell_columns.include?(cell.cell_column) && cell.has_mine?
    end
  end

  private_class_method :surrounding_mines

  def reveal(column, row)
    cell_to_reveal = cells.find_by!(cell_column: column, row: row)
    cell_to_reveal.reveal

    free_cells = free_cells_to_reveal_from(cell_to_reveal.row, cell_to_reveal.cell_column)

    free_cells.map(&:reveal)
  rescue ActiveRecord::RecordNotFound
    raise "cell (#{column},#{row}) does not exist"
  end

  def loosed?
    mines.any?(&:revealed?)
  end

  def mines
    cells.where(has_mine: true)
  end

  def inspect
    cells_by_row = cells.each_slice(columns).to_a
    "#{cells_by_row.map { |cells| cells.map(&:inspect).join(' ').to_s }.join("\n")}\n"
  end

  private

  def free_cells_to_reveal_from(row, column, cells_to_reveal = [])
    return cells_to_reveal if out_of_bounds?(column, row)
    
    cell_to_reveal = free_cell_at(column, row)

    return cells_to_reveal if cell_to_reveal.blank?

    return if cells_to_reveal.include?(cell_to_reveal)

    if !cell_to_reveal.surrounding_mines?
      cells_to_reveal << cell_to_reveal
      free_cells_to_reveal_from(row + 1, column, cells_to_reveal)
      free_cells_to_reveal_from(row - 1, column, cells_to_reveal)
      free_cells_to_reveal_from(row, column + 1, cells_to_reveal)
      free_cells_to_reveal_from(row, column - 1, cells_to_reveal)
    elsif cell_to_reveal.surrounding_mines?
      cells_to_reveal << cell_to_reveal
    else
      cells_to_reveal
    end
  end

  def free_cell_at(column, row)
    cells.find do |cell|
      cell.row == row && cell.cell_column == column && !cell.has_mine?
    end
  end

  def out_of_bounds?(column, row)
    (row > rows || column > columns) && (row <= 0 && column <= 0)
  end
end
