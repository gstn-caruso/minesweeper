class Cell < ApplicationRecord
  has_one :game

  def reveal
    update!(revealed: true)
  end
end
