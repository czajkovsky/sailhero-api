class AddAlertIdToAlertConfirmations < ActiveRecord::Migration
  def change
    add_column :alert_confirmations, :alert_id, :integer
  end
end
