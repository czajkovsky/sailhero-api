class CreateAlertConfirmation < ActiveRecord::Migration
  def change
    create_table :alert_confirmations do |t|
      t.integer :user_id
      t.boolean :up
      t.timestamps
    end
  end
end
