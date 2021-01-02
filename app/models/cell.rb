class Cell < ApplicationRecord
  has_one :game

  def reveal
    update!(revealed: true)
  end

  def surrounding_mines?
    surrounding_mines.positive?
  end
end
