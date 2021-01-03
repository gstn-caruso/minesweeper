class GameSerializer < ActiveModel::Serializer
  attributes :id, :cells

  def cells
    game_cell_contents = object.cells.map do |cell|
      display_cell_content(cell)
    end

    game_cell_contents.sort do |cell, next_cell|
      [cell[:row], cell[:column]] <=> [next_cell[:row], next_cell[:column]]
    end
  end

  private

  def display_cell_content(cell)
    {
      row: cell.row,
      column: cell.cell_column,
      value: cell_value(cell)
    }
  end

  def cell_value(cell)
    if cell.revealed?
      cell.has_mine ? 'M' : cell.surrounding_mines.to_s
    else
      '?'
    end
  end
end
