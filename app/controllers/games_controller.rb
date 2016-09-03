class GamesController < ApplicationController

  def create
    p params
    render json: {status: :ok}
  end

  def show
    p params
    render json: {
      status: :ok,
      figure: 0
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

  def connects? group_1, group_2, board
    for x in 0..board.length-1
      for y in 0..board.length-1
        if board[y][x] == group_1 then
          if neighbours(x,y, board).any?{|group| group==group_2} then
            return true
          end
        end
      end
    end
    return false
  end

  def neighbours x, y, board
    neighbours = [] << board[y+1][x] if x < board[0].length
    neighbours << board[y][x+1] if y < board.length
    neighbours << board[y-1][x] if y > 0
    neighbours << board[y][x-1] if x > 0
    return neighbours
  end
  #color array = [[-1,-1...]] if no color
  #group and color are numbers
  def change_color group, color, board, colorArray
    for x in 0..board.length-1
      for y in 0..board.length-1
        colorArray[y][x] = color if board[y][x] == group
      end
    end
    colorArray
  end
end
