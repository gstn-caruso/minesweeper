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
      small_grid = GameLevel.custom(1, 1, 1)

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

    context 'when chosen cell has no mine' do
      it 'reveals surrounding cells with no mines around' do
        no_mines = []
        small_grid = GameLevel.custom(2, 2, 0)

        game = described_class.create_with_level(small_grid, no_mines)

        game.reveal(1, 1)

        free_cells = game.cells

        expect(free_cells.all?(&:revealed?)).to be(true)
      end
    end
  end
end
