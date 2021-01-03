class GamesController < ActionController::API

  def reveal
    game = Game.find(cell_params[:id])
    game.reveal(cell_params[:column], cell_params[:row])

    render status: :ok, json: game

  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "There is no game with id: #{cell_params[:id]}" }
  rescue ActionController::ParameterMissing, Game::CellNotFound, Game::GameOver => e
    render status: :bad_request, json: { error: e.message }
  end

  def create
    game = Game.create_easy
    render status: :created, json: game
  end

  def show
    render status: :found, json: Game.includes(:cells).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "There is no game with id: #{params[:id]}" }
  end

  private

  def cell_params
    required_params = ['id', 'row', 'column']
    missing_params = required_params.difference(params.keys)

    raise ActionController::ParameterMissing, missing_params.join(', ') if missing_params.any?

    params.permit(:id, :row, :column)
  end
end
