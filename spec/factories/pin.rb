FactoryGirl.define do
  factory :pin do
    latitude Faker::Address.latitude.to_d.round(6)
    longitude Faker::Address.longitude.to_d.round(6)
  end
end
