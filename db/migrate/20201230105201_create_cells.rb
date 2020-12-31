class CreateCells < ActiveRecord::Migration[6.0]
  def change
    create_table :cells do |t|
      t.belongs_to :game, foreign_key: true
      t.integer :column
      t.integer :row

      t.boolean :has_mine, null: false, default: false
      t.boolean :revealed, null: false, default: false
      t.integer :surrounding_mines, null: false, default: 0

      t.timestamps
    end
  end
end
