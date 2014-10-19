class ChangePortLatLngTypes < ActiveRecord::Migration
  def up
    change_column :ports, :latitude, :decimal, precision: 10, scale: 6
    change_column :ports, :longitude, :decimal, precision: 10, scale: 6
    change_column :users, :latitude, :decimal, precision: 10, scale: 6
    change_column :users, :longitude, :decimal, precision: 10, scale: 6
    remove_column :alerts, :latitude, :string
    remove_column :alerts, :longitude, :string
    add_column :alerts, :latitude, :decimal, precision: 10, scale: 6
    add_column :alerts, :longitude, :decimal, precision: 10, scale: 6
    change_column :checkpoints, :latitude, :decimal, precision: 10, scale: 6
    change_column :checkpoints, :longitude, :decimal, precision: 10, scale: 6
    change_column :ports, :depth, :integer, default: 100
  end

  def down
    change_column :ports, :depth, :float
    change_column :users, :latitude, :float
    change_column :users, :longitude, :float
    change_column :checkpoints, :latitude, :float
    change_column :checkpoints, :longitude, :float
    change_column :ports, :latitude, :float
    change_column :ports, :longitude, :float
  end
end
