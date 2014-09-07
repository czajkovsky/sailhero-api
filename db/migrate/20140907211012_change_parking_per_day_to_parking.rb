class ChangeParkingPerDayToParking < ActiveRecord::Migration
  def change
    remove_column :ports, :price_parking_per_day
    add_column :ports, :price_parking, :float, default: 0.0
  end
end
