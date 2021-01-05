class Cell < ApplicationRecord
  FLAG = 'F'.freeze

  has_one :game

  def flag
    raise Game::PreconditionFailed, "Cell (#{cell_column},#{row}) is revealed" if revealed?

    if flagged?
      update!(content: nil)
    else
      update!(content: FLAG)
    end
  end

  def display_content
    return FLAG if flagged?
    return 'M' if has_mine? && revealed?
    return surrounding_mines.to_s if revealed?

    '?'
  end

  def reveal
    update!(revealed: true)
  end

  def flagged?
    content == FLAG
  end

  def surrounding_mines?
    surrounding_mines.positive?
  end
end
