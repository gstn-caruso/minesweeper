require 'rails_helper'

RSpec.describe 'Games', type: :request do
  def expect_to_have_json_body(response, expected_json_response)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    expect(JSON.parse(response.body)).to eq(expected_json_response.as_json)
  end

  describe '#show' do
    context 'when requested game does not exist' do
      it 'returns a 404 not found status' do
        requested_game_id = 1

        get "/games/#{requested_game_id}"

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
            cells: [
              ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
              ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
              ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
              ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
              ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
              ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
              ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
              ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
              ['?', '?', '?', '?', '?', '?', '?', '?', '?']
            ]
          }
        }

        get "/games/#{game.id}"

        expect(response).to have_http_status(:found)
        expect_to_have_json_body(response, expected_game)
      end
    end
  end

  describe '#create' do
    it 'creates a new game and returns it' do
      expect { post '/games' }.to change { Game.count }.by(1)

      created_game_id = JSON.parse(response.body)['game']['id']

      expected_game_response = {
        game: {
          id: created_game_id,
          cells: [
            ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
            ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
            ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
            ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
            ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
            ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
            ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
            ['?', '?', '?', '?', '?', '?', '?', '?', '?'],
            ['?', '?', '?', '?', '?', '?', '?', '?', '?']
          ]
        }
      }

      expect(response).to have_http_status(:created)
      expect_to_have_json_body(response, expected_game_response)
    end
  end
end
