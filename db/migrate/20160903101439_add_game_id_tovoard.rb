class AddGameIdTovoard < ActiveRecord::Migration[5.0]
  def change
    add_column :boards, :game_id, :integer  
  end
end
