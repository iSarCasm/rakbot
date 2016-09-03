class GamesController < ApplicationController
  def create
    p params
    render json: {status: :ok}
  end

  def show
    p params
    render json: {
      status: :ok,
      figure: [0,1,2,3].sample
    }
  end

  def update
    p params
    render json: {status: :ok}
  end

  def destroy
    p params
    render json: {status: :ok}
  end
end
