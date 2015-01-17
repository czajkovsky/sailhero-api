class AddDefaultValueToSpots < ActiveRecord::Migration
  def change
    change_column :ports, :spots, :integer, default: 0
  end
end
