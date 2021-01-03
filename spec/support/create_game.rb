def create_game_with(rows, columns, mine_positions)
  game_level = GameLevel.new(rows, columns, mine_positions.length)
  Game.create_with_level(game_level, mine_positions)
end
