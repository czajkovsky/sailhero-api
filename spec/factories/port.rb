FactoryGirl.define do
  factory :yacht_size_range_price do
    min_length 0
    max_length 900
    price 40
    max_width 2_000
  end

  factory :port do
    name Faker::Company.name
    longitude Faker::Address.longitude.to_d.round(6)
    latitude Faker::Address.latitude.to_d.round(6)
    website 'http://example.com'
    city Faker::Address.city
    street Faker::Address.street_address
    telephone Faker::PhoneNumber.cell_phone
    additional_info Faker::Lorem.sentence
    spots 15
    depth 2.0
    price_per_person 10.0
    price_power_connection 10.0
    price_wc 0.0
    price_shower 12.0
    price_washbasin 2.0
    price_dishes 0.0
    price_wifi 0.0
    price_washing_machine 15.0
    price_emptying_chemical_toilet 0.0
    price_parking 0.0
    has_power_connection true
    has_wc true
    has_shower true
    has_washbasin true
    has_dishes true
    has_wifi true
    has_parking true
    has_slip false
    has_washing_machine true
    has_fuel_station false
    has_emptying_chemical_toilet true

    after(:create) do |port|
      create(:yacht_size_range_price, port: port)
    end
  end
end
