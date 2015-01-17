class UpdateAlertsRelation < ActiveRecord::Migration
  def change
    change_column :alerts, :user_id, :integer, null: false
    change_column :alerts, :region_id, :integer, null: false
  end
end
