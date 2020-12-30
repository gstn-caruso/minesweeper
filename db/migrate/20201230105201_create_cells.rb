class CreateCells < ActiveRecord::Migration[6.0]
  def change
    create_table :cells do |t|
      t.belongs_to :game, foreign_key: true
      t.integer :column
      t.integer :row

      t.boolean :has_mine, null: false, default: false
      t.string :content, null: false, default: ''

      t.timestamps
    end
  end
end
