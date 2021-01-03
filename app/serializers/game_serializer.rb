class GameSerializer < ActiveModel::Serializer
  attributes :id, :cells

  def cells
    game_cell_values = object.cells.map { |game_cell| display_cell_content(game_cell) }
    game_cell_values.each_slice(object.columns).to_a
  end

  private

  def display_cell_content(cell)
    if cell.revealed?
      cell.has_mine ? 'M' : cell.surrounding_mines.to_s
    else
      '?'
    end
  end
end
