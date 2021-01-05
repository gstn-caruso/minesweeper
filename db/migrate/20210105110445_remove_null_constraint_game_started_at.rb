class RemoveNullConstraintGameStartedAt < ActiveRecord::Migration[6.0]
  def change
    change_column_null :games, :started_at, true
  end
end
