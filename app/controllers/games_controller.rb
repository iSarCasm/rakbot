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

  def connects? group_1, group_2, board
    for x in 0..board.length-1
      for y in 0..board.length-1
        if board[y][x][:figure] == group_1 then
          if neighbours(x,y, board).any?{|group| group[:figure]==group_2} then
            return true
          end
        end
      end
    end
    return false
  end

  def neighbours x, y, board
    neighbours = []
    neighbours << board[y+1][x] if y+1 < board.length
    neighbours << board[y][x+1] if x+1 < board[0].length
    neighbours << board[y-1][x] if y-1 > 0
    neighbours << board[y][x-1] if x-1 > 0
    neighbours << board[y-1][x-1] if x-1 > 0 && y-1 > 0
    neighbours << board[y+1][x+1] if x+1 < board[0].length && y+1 < board.length
    return neighbours
  end
  #color array = [[-1,-1...]] if no color
  #group and color are numbers
  def change_color group, color, board
    for x in 0..board.length-1
      for y in 0..board.length-1
        board[y][x][:color] = color if board[y][x][:figure] == group
      end
    end
  end

  def good_figures board, figure_count
    figures = (1..figure_count).to_a
    #ba.each{|row| row.each{|elem| elem[:color]}}
    for x in 0..board.length-1
      for y in 0..board.length-1
        figures.delete(board[y][x][:figure]) if board[y][x][:color] != nil
      end
    end
    figures
  end
end
