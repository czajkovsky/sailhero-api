class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :longitude
      t.string :latitude
      t.string :user_id_integer
      t.string :alert_type
      t.text :additional_info

      t.timestamps
    end
  end
end
