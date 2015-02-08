FactoryGirl.define do
  factory :user do
    name 'John'
    surname 'Doe'
    email 'john.doe@example.com'
    password 'r4nd0miZedp4ssw0rd!'
    password_confirmation 'r4nd0miZedp4ssw0rd!'
    latitude Faker::Address.latitude.to_d.round(6)
    longitude Faker::Address.longitude.to_d.round(6)
    position_updated_at '2014-12-16 22:33:02'
    active true
  end

  factory :user_with_avatar, class: User do
    name 'Scarlett'
    surname 'Johansson'
    email 'scarlett1986@example.com'
    password 'r4nd0miZedp4ssw0rd!'
    password_confirmation 'r4nd0miZedp4ssw0rd!'
    active true
    avatar_data 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAkAAAAKCAMAAABR24SMAAAAS1BMVEUAAAD////9/f36+vr29vY0NDTv7+/o6Oji4uLY2NjPz8/Gxsa+vr69vb21tbWrq6uXl5eEhIR2dnZiYmJQUFBAQEAoKCgbGxsLCwuaD98CAAAAOUlEQVQI1zXGxxHAIAwAMBMgCb2X/SeFA1svAWPcStj2RBi4N86750uA+zNNFZquOG4azUmc8P1kAUOXAU4MfwsyAAAAAElFTkSuQmCC'
  end
end
