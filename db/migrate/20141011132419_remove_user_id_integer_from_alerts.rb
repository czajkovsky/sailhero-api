class RemoveUserIdIntegerFromAlerts < ActiveRecord::Migration
  def change
    remove_column :alerts, :user_id_integer, :string
    add_column :alerts, :user_id, :integer
  end
end
