FactoryGirl.define do
  factory :user do
    name 'John'
    surname 'Doe'
    email 'john.doe@example.com'
    password 'password1'
    password_confirmation 'password1'
  end
end
