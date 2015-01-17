class UpdateDevicesRelation < ActiveRecord::Migration
  def change
    change_column :devices, :user_id, :integer, null: false
    change_column :devices, :token_id, :integer, null: false
  end
end
