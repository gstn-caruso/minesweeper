class AddGameLevelSettingsToGame < ActiveRecord::Migration[6.0]
  def change
    change_table :games, bulk: true do |table|
      table.column :rows, :integer, null: false, default: 0
      table.column :columns, :integer, null: false, default: 0
      table.column :mines, :integer, null: false, default: 0
    end
  end
end
