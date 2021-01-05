require 'swagger_helper'

RSpec.describe 'Game API', type: :request do
  path '/api/games/{id}' do
    get 'Retrieves a game' do
      tags Game
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '200', 'Found game' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 cells: {
                   type: :object,
                   properties: {
                     row: { type: :integer },
                     column: { type: :integer },
                     value: {
                       type: :string,
                       enum: (1..9).to_a.concat(['?', 'M'])
                     }
                   }
                 }
               }
        let(:id) { Game.create_easy.id }
        run_test!
      end

      response '404', 'Not found' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { -1 }
        run_test!
      end
    end
  end

  path '/api/games' do
    post 'Creates a new Game' do
      tags Game
      produces 'application/json'

      response '201', 'Created game' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 cells: {
                   type: :object,
                   properties: {
                     row: { type: :integer },
                     column: { type: :integer },
                     value: {
                       type: :string,
                       enum: (1..9).to_a.concat(['?', 'M'])
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/games/{id}/reveal' do
    post 'Reveals a cell' do
      tags Game
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          row: {
            type: :integer
          },
          column: {
            type: :integer
          }
        },
        required: ['row', 'column']
      }

      response '200', 'Updated game' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 cells: {
                   type: :object,
                   properties: {
                     row: { type: :integer },
                     column: { type: :integer },
                     value: {
                       type: :string,
                       enum: (1..9).to_a.concat(['?', 'M'])
                     }
                   }
                 }
               }

        let(:id) { Game.create_easy.id }
        let(:params) { { row: 1, column: 1 } }

        run_test!
      end

      response '404', 'Game not found' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { -1 }
        let(:params) { { row: 1, column: 1 } }

        run_test!
      end

      response '400', 'Cell not found, Finished game and Missing cell information' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { Game.create_easy.id }
        let(:params) { { row: 99, column: 99 } }

        run_test!
      end
    end
  end

  path '/api/games/{id}/flag' do
    post 'Flags a cell' do
      tags Game
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          row: {
            type: :integer
          },
          column: {
            type: :integer
          }
        },
        required: ['row', 'column']
      }

      response '200', 'Updated game' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 cells: {
                   type: :object,
                   properties: {
                     row: { type: :integer },
                     column: { type: :integer },
                     value: {
                       type: :string,
                       enum: (1..9).to_a.concat(['?', 'M'])
                     }
                   }
                 }
               }

        let(:id) { Game.create_easy.id }
        let(:params) { { row: 1, column: 1 } }

        run_test!
      end

      response '404', 'Game not found' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { -1 }
        let(:params) { { row: 1, column: 1 } }

        run_test!
      end

      response '400', 'Cell not found, Finished game and Missing cell information' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { Game.create_easy.id }
        let(:params) { { row: 99, column: 99 } }

        run_test!
      end
    end
  end
end
