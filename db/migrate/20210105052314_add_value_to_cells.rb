class AddValueToCells < ActiveRecord::Migration[6.0]
  def change
    add_column :cells, :content, :string
  end
end
