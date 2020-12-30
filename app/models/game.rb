class Game < ApplicationRecord
  has_many :cells, autosave: true
end
