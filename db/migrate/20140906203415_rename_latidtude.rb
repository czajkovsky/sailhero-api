class RenameLatidtude < ActiveRecord::Migration
  def change
    remove_column :map_ports, :latidude
    add_column :map_ports, :latitude, :float, default: 0.0

    remove_column :map_ports, :longitude
    add_column :map_ports, :longitude, :float, default: 0.0
  end
end
