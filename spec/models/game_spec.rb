require 'rails_helper'
require 'matrix'

RSpec.describe Game, type: :model do
  let(:beginner_level) { GameLevel.beginner }

  def expect_game_to_eq(game, expected_rows)
    game_cell_values = game.cells.reload.map(&:display_content)
    game_cells_by_row = game_cell_values.each_slice(game.columns).to_a

    game_result = Matrix.rows(game_cells_by_row)
    expected = Matrix.rows(expected_rows)

    expect(game_result).to eq(expected)
  end

  it 'wins when all free cells are revealed' do
    expected_game_result = [
      ['?', '1', '0'],
      ['1', '1', '0']
    ]

    game = create_game_with(2, 3, [1])

    game.reveal(3, 1)
    game.reveal(2, 1)
    game.reveal(1, 2)

    expect(game).to be_won
    expect_game_to_eq(game, expected_game_result)
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
      game = create_game_with(2, 2, [1])

      game.reveal(1, 1)

      expect(game).to be_loosed
    end

    it 'fails when chosen cell does not exist' do
      game = described_class.create_easy

      expect do
        game.reveal(99, 99)
      end.to raise_exception('Cell (99,99) does not exist')

      expect(game).not_to be_loosed
    end

    it 'fails and do nothing when game is loosed' do
      expected_game_result = [
        ['M', '?'],
        ['?', '?']
      ]

      game = create_game_with(2, 2, [1])
      game.reveal(1, 1)

      expect { game.reveal(1, 2) }.to raise_exception('Game over')

      expect(game.reload).to be_loosed
      expect_game_to_eq(game, expected_game_result)
    end

    it 'fails and do nothing when game is already won' do
      expected_game_result = [
        ['?', '1'],
        ['1', '1']
      ]

      game = create_game_with(2, 2, [1])

      game.reveal(2, 1)
      game.reveal(1, 2)
      game.reveal(2, 2)

      expect { game.reveal(1, 1) }.to raise_exception('Game over')

      expect(game.reload).to be_won
      expect_game_to_eq(game, expected_game_result)
    end

    context 'when chosen cell has no mines around' do
      it 'reveals left cells until it reaches a cell surrounding a mine' do
        expected_game_result = [
          ['?', '?', '1', '0', '0']
        ]

        game = create_game_with(1, 5, [2])

        game.reveal(5, 1)

        expect_game_to_eq(game, expected_game_result)
      end

      it 'reveals left cells up to the corner if there are no mine' do
        expected_game_result = [
          ['0', '0', '0', '0', '0']
        ]

        game = create_game_with(1, 5, [])

        game.reveal(5, 1)

        expect_game_to_eq(game, expected_game_result)
      end

      it 'reveals right cells until it reaches a cell surrounding a mine' do
        expected_game_result = [
          ['0', '0', '1', '?', '?']
        ]

        game = create_game_with(1, 5, [4])

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

        game = create_game_with(5, 1, [4])

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

        game = create_game_with(5, 1, [])

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

        game = create_game_with(5, 1, [])

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

        game = create_game_with(5, 1, [2])

        game.reveal(1, 5)

        expect_game_to_eq(game, expected_game_result)
      end
    end

    it 'reveals surrounding cells with no mines around' do
      expected_game_result = [
        ['0', '0'],
        ['0', '0']
      ]

      game = create_game_with(2, 2, [])

      game.reveal(1, 1)

      expect_game_to_eq(game, expected_game_result)
    end

    it 'reveals surrounding cells until it reaches a mine, storing surrounding mines' do
      expected_game_result = [
        ['0', '1', '?'],
        ['0', '1', '?']
      ]

      game = create_game_with(2, 3, [6])

      game.reveal(1, 1)

      expect_game_to_eq(game, expected_game_result)
    end
  end

  describe 'flag a cell' do
    it 'returns the game with that cell flagged' do
      expected_game_result = [
        ['F', '?', '?'],
        ['?', '?', '?']
      ]

      game = create_game_with(2, 3, [])

      game.flag(1, 1)

      expect_game_to_eq(game, expected_game_result)
    end

    it 'cleans the cell when it is flagged twice' do
      expected_game_result = [
        ['?', '?', '?'],
        ['?', '?', '?']
      ]

      game = create_game_with(2, 3, [])

      game.flag(1, 1)
      game.flag(1, 1)

      expect_game_to_eq(game, expected_game_result)
    end

    it 'treats that cell as it would have a surrounding mine when it reveals surrounding cells' do
      expected_game_result = [
        ['0', '1', '?'],
        ['F', '?', '?']
      ]

      game = create_game_with(2, 3, [6])

      game.flag(1, 2)
      game.reload
      game.reveal(1, 1)

      expect_game_to_eq(game, expected_game_result)
    end

    it 'fails when the cell is already revealed' do
      game = create_game_with(2, 3, [6])

      game.reveal(1, 1)
      game.reload

      expect do
        game.flag(1, 1)
      end.to raise_exception('Cell (1,1) is revealed')
    end

    it 'fails when game is finished' do
      game = create_game_with(2, 3, [6])

      game.reveal(1, 1)
      game.reveal(3, 1)
      game.reload

      expect(game).to be_won

      expect do
        game.flag(3, 2)
      end.to raise_exception('Game over')
    end
  end
end
