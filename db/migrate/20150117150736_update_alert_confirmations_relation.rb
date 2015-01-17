class UpdateAlertConfirmationsRelation < ActiveRecord::Migration
  def change
    change_column :alert_confirmations, :user_id, :integer, null: false
    change_column :alert_confirmations, :alert_id, :integer, null: false
  end
end
