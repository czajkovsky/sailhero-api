class PortSerializer < ActiveModel::Serializer
  attributes :id, :name, :latitude, :longitude, :website, :city, :street,
             :telephone, :additional_info, :spots, :depth,
             :has_power_connection, :has_wc, :has_shower, :has_washbasin,
             :has_dishes, :has_wifi, :has_parking, :has_slip,
             :has_washing_machine, :has_fuel_station,
             :has_emptying_chemical_toilet,
             :price_per_person, :price_power_connection, :price_wc,
             :price_shower, :price_washbasin, :price_dishes, :price_wifi,
             :price_washing_machine, :price_emptying_chemical_toilet,
             :price_parking
end
