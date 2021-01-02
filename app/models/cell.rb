class Cell < ApplicationRecord
  has_one :game

  def reveal
    update!(revealed: true)
  end

  def surrounding_mines?
    surrounding_mines.positive?
  end

  def inspect
    if revealed?
      has_mine ? 'M' : surrounding_mines
    else
      '?'
    end
  end
end
