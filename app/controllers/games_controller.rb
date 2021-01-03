class GamesController < ActionController::API

  def show
    render status: :found, json: Game.includes(:cells).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "There is no game with id: #{params[:id]}" }
  end
end
