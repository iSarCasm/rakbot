class GamesController < ApplicationController
  def create
    p params
    cells = params["board"]["cells"]
    cells.map! do |row|
      row.map! do |e|
        {"figure" => e, "color" => nil}
      end
    end

    b = Board.create(game_id: params["id"], width: params["board"]["width"], height: params["board"]["height"], figures: params["board"]["figures_count"], cells: cells.to_json, first_turn: params["first_turn"], turn: 0)
    p b
    render json: {status: :ok}
  end

  def show
    p params
    b = Board.where("game_id = ?", params["id"]).first
    b.turn += 1

    cells = JSON.parse(b.cells)

    current_color = params["color"]
    p cells
    figs = good_figures cells, b.figures
    p "good cells are: #{figs}"
    figs = very_good_cells(current_color, figs, b.figures, cells)
    p "very good cells are: #{figs}"
    figs.sort! do |x,y|
      figure_volume(x, cells) <=> figure_volume(y, cells)
    end
    x = figs.last
    puts "HELLO I SELECT: #{x}"

    b.save
    render json: {
      status: :ok,
      figure: x
    }
  end

  def update
    p params
    b = Board.where("game_id = ?", params["id"]).first
    p b.cells
    cells = JSON.parse(b.cells)
    p cells
    change_color params["figure"], params["color"], cells
    b.update(cells: cells.to_json)
    p "new cells"
    p cells
    b.save
    p "new"
    p b.cells
    render json: {status: :ok}
  end

  def destroy
    p params
    render json: {status: :ok}
  end

  def figure_volume figure, board
    volume = 0
    board.each do |row|
      row.each do |x|
        volume += 1 if x["figure"] == figure
      end
    end
    volume
  end

  def very_good_cells color, figures, fig_count, cells
    p cells
    p neighbours 0, 0, cells
    a = figures.delete_if do |fig|
      (0...fig_count).to_a.any? do |x|
        puts "Figure #{fig} connects #{x}? = #{connects?(fig, x, cells)}"
        puts "Same color #{color} and #{group_color(x, cells)}? = #{color.to_i == group_color(x, cells).to_i}"
        connects?(fig, x, cells) && color.to_i == group_color(x, cells).to_i
      end
    end
    a
  end

  def group_color group, board
    board.flatten.find{|item| item["figure"] == group}["color"]
  end

  def connects? group_1, group_2, board
    for x in 0..board.length-1
      for y in 0..board.length-1
        if board[y][x]["figure"] == group_1 then
          if neighbours(x,y, board).any?{|group| group["figure"]==group_2} then
            return true
          end
        end
      end
    end
    return false
  end

  def neighbours x, y, board
    neighbours = []
    neighbours << board[y][x+1] if x+1 < board[0].length
    neighbours << board[y][x-1] if x-1 > 0
    if(y.odd?) then
      neighbours << board[y-1][x] if y - 1 > 0
      neighbours << board[y-1][x+1] if y -1 > 0 && x + 1 < board[0].length
      neighbours << board[y+1][x] if y + 1 < board.length
      neighbours << board[y+1][x+1] if x + 1 < board[0].length && y + 1 < board.length
    else
      neighbours << board[y-1][x-1] if y-1 > 0 && x-1 > 0
      neighbours << board[y-1][x] if y-1 > 0
      neighbours << board[y+1][x-1] if x-1 > 0 && y+1 < board.length
      neighbours << board[y+1][x] if y+1 < board.length
    end
    return neighbours
  end
  #color array = [[-1,-1...]] if no color
  #group and color are numbers
  def change_color group, color, board
    board.map! do |row|
      row.map! do |x|
        {"figure" => x["figure"], "color" => (x["figure"] == group ? color : x["color"])}
      end
    end
  end

  def good_figures board, figure_count
    figures = (0...figure_count).to_a
    #ba.each{|row| row.each{|elem| elem[:color]}}
    for x in 0..board.length-1
      for y in 0..board.length-1
        figures.delete(board[y][x]["figure"]) if board[y][x]["color"] != nil
      end
    end
    figures
  end
end
