# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :training do
    started_at "2014-10-05 19:20:18"
    finished_at "2014-10-05 19:20:18"
    distance 1.5
    user_id 1
  end
end
