require 'rails_helper'

RSpec.describe 'Games', type: :request do
  def expect_to_have_json_body(response, expected_json_response)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    expect(JSON.parse(response.body)).to eq(expected_json_response.as_json)
  end

  def beginner_game_unrevealed_cells
    expected_cells = []
    beginner_game_level = GameLevel.beginner

    (1..beginner_game_level.rows).each do |row|
      (1..beginner_game_level.columns).each do |column|
        expected_cells << { row: row, column: column, value: '?' }
      end
    end

    expected_cells
  end


  describe '#show' do
    context 'when requested game does not exist' do
      it 'returns a 404 not found status' do
        requested_game_id = 1

        get "/api/games/#{requested_game_id}"

        expect(response).to have_http_status(:not_found)
        expect_to_have_json_body(response,
                                 { error: "There is no game with id: #{requested_game_id}" })
      end
    end

    context 'when there is a game with requested id' do
      let(:game) { Game.create_easy }

      it 'returns the game' do
        expected_game = {
          game: {
            id: game.id,
            cells: beginner_game_unrevealed_cells
          }
        }

        get "/api/games/#{game.id}"

        expect(response).to have_http_status(:found)
        expect_to_have_json_body(response, expected_game)
      end
    end
  end

  describe '#create' do
    it 'creates a new game and returns it' do
      expect { post '/api/games' }.to change { Game.count }.by(1)

      created_game_id = JSON.parse(response.body)['game']['id']

      expected_game_response = {
        game: {
          id: created_game_id,
          cells: beginner_game_unrevealed_cells
        }
      }

      expect(response).to have_http_status(:created)
      expect_to_have_json_body(response, expected_game_response)
    end
  end

  describe '#reveal' do
    it 'fails with bad request when no cell information was given' do
      game = Game.create_easy

      expect { post "/api/games/#{game.id}/reveal" }.not_to(change { game.cells.any?(&:revealed?) })

      expect(response).to have_http_status(:bad_request)
      expect_to_have_json_body(response, { error: 'param is missing or the value is empty: row, column' })
    end

    it 'fails with not found error when game can not be found' do
      requested_game_id = 1

      post "/api/games/#{requested_game_id}/reveal", params: { row: 1, column: 1 }

      expect(response).to have_http_status(:not_found)
      expect_to_have_json_body(response, { error: "There is no game with id: #{requested_game_id}" })
    end

    it 'fails when cell can not be found' do
      game = Game.create_easy

      expect { post "/api/games/#{game.id}/reveal", params: { row: 99, column: 99 } }
        .not_to(change { game.reload.cells.any?(&:revealed?) })

      expect(response).to have_http_status(:bad_request)
      expect_to_have_json_body(response, { error: 'Cell (99,99) does not exist' })
    end

    it 'fails when game is over' do
      game = create_game_with(2, 2, [1])

      post "/api/games/#{game.id}/reveal", params: { row: 1, column: 1 }

      expect { post "/api/games/#{game.id}/reveal", params: { row: 1, column: 2 } }
        .not_to(change { game.reload.cells.any?(&:revealed?) })

      expect(response).to have_http_status(:bad_request)
      expect_to_have_json_body(response, { error: 'Game over' })
    end

    it 'reveals selected cell and returns the game' do
      game = Game.create_easy

      expect { post "/api/games/#{game.id}/reveal", params: { row: 1, column: 1 } }
        .to(change { game.reload.cells.any?(&:revealed?) }.from(false).to(true))

      returned_game = JSON.parse(response.body)['game']

      expect(response).to have_http_status(:ok)
      expect(returned_game.keys).to eq(%w[id cells])
    end
  end
end
