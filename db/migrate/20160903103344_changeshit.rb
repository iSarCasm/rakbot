class Changeshit < ActiveRecord::Migration[5.0]
  def change
    change_column :boards, :game_id, :string
  end
end
