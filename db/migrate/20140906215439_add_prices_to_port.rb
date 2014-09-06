class AddPricesToPort < ActiveRecord::Migration
  def change
    add_column :ports, :website, :string
    add_column :ports, :city, :string
    add_column :ports, :street, :string
    add_column :ports, :telephone, :string
    add_column :ports, :additional_info, :string

    add_column :ports, :spots, :integer, defalut: 0
    add_column :ports, :depth, :float, default: -1.0

    add_column :ports, :price_per_person, :float, default: 0
    add_column :ports, :price_power_connection, :float, default: 0
    add_column :ports, :price_wc, :float, default: 0
    add_column :ports, :price_shower, :float, default: 0
    add_column :ports, :price_washbasin, :float, default: 0
    add_column :ports, :price_dishes, :float, default: 0
    add_column :ports, :price_wifi, :float, default: 0
    add_column :ports, :price_parking_per_day, :float, default: 0
    add_column :ports, :price_washing_machine, :float, default: 0
    add_column :ports, :price_emptying_chemical_toilet, :float, default: 0

    add_column :ports, :has_power_connection, :boolean, default: true
    add_column :ports, :has_wc, :boolean, default: true
    add_column :ports, :has_shower, :boolean, default: true
    add_column :ports, :has_washbasin, :boolean, default: true
    add_column :ports, :has_dishes, :boolean, default: true
    add_column :ports, :has_wifi, :boolean, default: true
    add_column :ports, :has_parking, :boolean, default: true
    add_column :ports, :has_slip, :boolean, default: false
    add_column :ports, :has_washing_machine, :boolean, default: true
    add_column :ports, :has_fuel_station, :boolean, default: false
    add_column :ports, :has_emptying_chemical_toilet, :boolean, default: true
  end
end
