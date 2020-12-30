require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'Beginner level' do
    let(:beginner_level) { GameLevel.beginner }

    it 'crates a 9x9 game by default' do
      game = described_class.create_easy
      expect(game.cells.length).to be(beginner_level.cells)
    end

    it 'contains 10 mines by default' do
      game = described_class.create_easy
      expect(game.mines.length).to be(beginner_level.mines)
    end
  end
end
