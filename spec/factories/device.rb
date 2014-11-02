FactoryGirl.define do
  factory :device do
    device_type 'ANDROID'
    name "John's phone"
    key 'J0hnsS3creTkey'
    user_id 1
    token_id 1
  end
end
