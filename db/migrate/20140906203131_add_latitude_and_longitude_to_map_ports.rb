class AddLatitudeAndLongitudeToMapPorts < ActiveRecord::Migration
  def change
    add_column :map_ports, :latidude, :float
    add_column :map_ports, :longitude, :float
  end
end
