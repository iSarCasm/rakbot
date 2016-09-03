class Addshitstuff < ActiveRecord::Migration[5.0]
  def change
    add_column :boards, :first_turn, :boolean
    add_column :boards, :turn, :integer  
  end
end
