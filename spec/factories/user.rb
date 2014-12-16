FactoryGirl.define do
  factory :user do
    name 'John'
    surname 'Doe'
    email 'john.doe@example.com'
    password 'password1'
    password_confirmation 'password1'
    active true
  end

  factory :user_with_avatar, class: User do
    name 'Scarlett'
    surname 'Johansson'
    email 'scarlett1986@example.com'
    password 'scarlett11'
    password_confirmation 'scarlett11'
    active true
    avatar_data 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAkAAAAKCAMAAABR24SMAAAAS1BMVEUAAAD////9/f36+vr29vY0NDTv7+/o6Oji4uLY2NjPz8/Gxsa+vr69vb21tbWrq6uXl5eEhIR2dnZiYmJQUFBAQEAoKCgbGxsLCwuaD98CAAAAOUlEQVQI1zXGxxHAIAwAMBMgCb2X/SeFA1svAWPcStj2RBi4N86750uA+zNNFZquOG4azUmc8P1kAUOXAU4MfwsyAAAAAElFTkSuQmCC'
  end
end
