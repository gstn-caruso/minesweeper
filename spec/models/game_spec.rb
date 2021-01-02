require 'rails_helper'
require 'matrix'

RSpec.describe Game, type: :model do
  let(:beginner_level) { GameLevel.beginner }

  def game_with(rows, columns, mine_positions)
    game_level = GameLevel.new(rows, columns, mine_positions.length)
    described_class.create_with_level(game_level, mine_positions)
  end

  def display_cell_content(cell)
    if cell.revealed?
      cell.has_mine ? 'M' : cell.surrounding_mines.to_s
    else
      '?'
    end
  end

  def expect_game_to_eq(game, expected_rows)
    game_cell_values = game.cells.map { |game_cell| display_cell_content(game_cell) }
    game_cells_by_row = game_cell_values.each_slice(game.columns).to_a

    game_result = Matrix.rows(game_cells_by_row)
    expected = Matrix.rows(expected_rows)

    expect(game_result).to eq(expected)
  end

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
      game = game_with(1, 1, [1])

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
        expected_game_result = [
          ['?', '?', '1', '0', '0']
        ]

        game = game_with(1, 5, [2])

        game.reveal(5, 1)

        expect_game_to_eq(game, expected_game_result)
      end

      it 'reveals left cells up to the corner if there are no mine' do
        expected_game_result = [
          ['0', '0', '0', '0', '0']
        ]

        game = game_with(1, 5, [])

        game.reveal(5, 1)

        expect_game_to_eq(game, expected_game_result)
      end

      it 'reveals right cells until it reaches a cell surrounding a mine' do
        expected_game_result = [
          ['0', '0', '1', '?', '?']
        ]

        game = game_with(1, 5, [4])

        game.reveal(1, 1)

        expect_game_to_eq(game, expected_game_result)
      end

      it 'reveals below cells until it reaches a cell surrounding a mine' do
        expected_game_result = [
          ['0'],
          ['0'],
          ['1'],
          ['?'],
          ['?']
        ]

        game = game_with(5, 1, [4])

        game.reveal(1, 1)

        expect_game_to_eq(game, expected_game_result)
      end

      it 'reveals below cells up to the corner if there are no mines' do
        expected_game_result = [
          ['0'],
          ['0'],
          ['0'],
          ['0'],
          ['0']
        ]

        game = game_with(5, 1, [])

        game.reveal(1, 1)

        expect_game_to_eq(game, expected_game_result)
      end

      it 'reveals above cells until it reaches a cell surrounding a mine' do
        expected_game_result = [
          ['0'],
          ['0'],
          ['0'],
          ['0'],
          ['0']
        ]

        game = game_with(5, 1, [])

        game.reveal(1, 5)

        expect_game_to_eq(game, expected_game_result)
      end

      it 'reveals above cells until it reaches a cell surrounding a mine' do
        expected_game_result = [
          ['?'],
          ['?'],
          ['1'],
          ['0'],
          ['0']
        ]

        game = game_with(5, 1, [2])

        game.reveal(1, 5)

        expect_game_to_eq(game, expected_game_result)
      end
    end

    it 'reveals surrounding cells with no mines around' do
      expected_game_result = [
        ['0', '0'],
        ['0', '0']
      ]

      game = game_with(2, 2, [])

      game.reveal(1, 1)

      expect_game_to_eq(game, expected_game_result)
    end

    it 'reveals surrounding cells until it reaches a mine, storing surrounding mines' do
      expected_game_result = [
        ['0', '1', '?'],
        ['0', '1', '?']
      ]

      game = game_with(2, 3, [6])

      game.reveal(1, 1)

      expect_game_to_eq(game, expected_game_result)
    end
  end
end
