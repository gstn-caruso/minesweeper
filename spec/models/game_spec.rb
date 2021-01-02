require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:beginner_level) { GameLevel.beginner }

  describe 'Beginner level' do
    it 'crates a 9x9 game by default' do
      game = described_class.create_easy
      expect(game.cells.length).to be(beginner_level.cells)
    end

    it 'contains 10 mines by default' do
      game = described_class.create_easy
      expect(game.mines.length).to be(beginner_level.mines)
    end
  end

  describe 'Revealing cells' do
    it 'looses when the chosen cell has a mine' do
      mine_positions = [1]
      small_grid = GameLevel.new(1, 1, 1)

      game = described_class.create_with_level(small_grid, mine_positions)

      game.reveal(1, 1)

      expect(game).to be_loosed
    end

    it 'fails when chosen cell does not exist' do
      game = described_class.create_easy

      expect do
        game.reveal(99, 99)
      end.to raise_exception('cell (99,99) does not exist')

      expect(game).not_to be_loosed
    end

    context 'when chosen cell has no mines around' do
      it 'reveals left cells until it reaches a cell surrounding a mine' do
        expected_game_result = <<~HEREDOC
          ? ? 1 0 0
        HEREDOC

        mines = [2]
        small_grid = GameLevel.new(1, 5, 1)

        game = described_class.create_with_level(small_grid, mines)

        game.reveal(5, 1)

        expect(game.reload.inspect).to eq(expected_game_result)
      end

      it 'reveals left cells up to the corner if there are no mine' do
        expected_game_result = <<~HEREDOC
          0 0 0 0 0
        HEREDOC

        mines = []
        small_grid = GameLevel.new(1, 5, 0)

        game = described_class.create_with_level(small_grid, mines)

        game.reveal(5, 1)

        expect(game.reload.inspect).to eq(expected_game_result)
      end

      it 'reveals right cells until it reaches a cell surrounding a mine' do
        expected_game_result = <<~HEREDOC
          0 0 1 ? ?
        HEREDOC

        mines = [4]
        small_grid = GameLevel.new(1, 5, 1)

        game = described_class.create_with_level(small_grid, mines)

        game.reveal(1, 1)

        expect(game.reload.inspect).to eq(expected_game_result)
      end

      it 'reveals below cells until it reaches a cell surrounding a mine' do
        expected_game_result = <<~HEREDOC
          0
          0
          1
          ?
          ?
        HEREDOC

        mines = [4]
        small_grid = GameLevel.new(5, 1, 1)

        game = described_class.create_with_level(small_grid, mines)

        game.reveal(1, 1)

        expect(game.reload.inspect).to eq(expected_game_result)
      end

      it 'reveals below cells up to the corner if there are no mines' do
        expected_game_result = <<~HEREDOC
          0
          0
          0
          0
          0
        HEREDOC

        mines = []
        small_grid = GameLevel.new(5, 1, 0)

        game = described_class.create_with_level(small_grid, mines)

        game.reveal(1, 1)

        expect(game.reload.inspect).to eq(expected_game_result)
      end
      
      it 'reveals above cells until it reaches a cell surrounding a mine' do
        expected_game_result = <<~HEREDOC
          0
          0
          0
          0
          0
        HEREDOC

        mines = []
        small_grid = GameLevel.new(5, 1, 0)

        game = described_class.create_with_level(small_grid, mines)

        game.reveal(1, 5)

        expect(game.reload.inspect).to eq(expected_game_result)
      end

      it 'reveals above cells until it reaches a cell surrounding a mine' do
        expected_game_result = <<~HEREDOC
          ?
          ?
          1
          0
          0
        HEREDOC

        mines = [2]
        small_grid = GameLevel.new(5, 1, 1)

        game = described_class.create_with_level(small_grid, mines)

        game.reveal(1, 5)

        expect(game.reload.inspect).to eq(expected_game_result)
      end
    end


    it 'reveals surrounding cells with no mines around' do
      no_mines = []
      small_grid = GameLevel.new(2, 2, 0)

      game = described_class.create_with_level(small_grid, no_mines)

      game.reveal(1, 1)

      expected_game_result = <<~HEREDOC
        0 0
        0 0
      HEREDOC

      expect(game.reload.inspect).to eq(expected_game_result)
    end

    it 'reveals surrounding cells until it reaches a mine, storing surrounding mines' do
      expected_game_result = <<~HEREDOC
        0 1 ?
        0 1 ?
      HEREDOC

      mines = [6]
      small_grid = GameLevel.new(2, 3, 1)

      game = described_class.create_with_level(small_grid, mines)

      game.reveal(1, 1)

      expect(game.reload.inspect).to eq(expected_game_result)
    end
  end
end
