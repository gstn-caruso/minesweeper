class GameLevel
  def self.custom(rows, columns, mines)
    game_settings = OpenStruct.new

    game_settings.mines = mines
    game_settings.rows = rows
    game_settings.columns = columns
    game_settings.cells = rows * columns

    game_settings
  end

  def self.beginner
    game_settings = OpenStruct.new

    rows = 9
    columns = 9

    game_settings.mines = 10
    game_settings.rows = rows
    game_settings.columns = columns
    game_settings.cells = rows * columns

    game_settings
  end
end
