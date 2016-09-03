class CreateBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :boards do |t|
      t.integer :width
      t.integer :height
      t.integer :figures
      t.text :cells
      t.timestamps
    end
  end
end
