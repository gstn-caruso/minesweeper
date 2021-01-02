class RenameCellColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :cells, :column, :cell_column
  end
end
