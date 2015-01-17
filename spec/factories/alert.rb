FactoryGirl.define do
  factory :alert do
    latitude Faker::Address.latitude.to_d.round(6)
    longitude Faker::Address.longitude.to_d.round(6)
    alert_type 'BAD_WEATHER_CONDITIONS'
    additional_info 'Lorem ipsum dolores'
  end
end
