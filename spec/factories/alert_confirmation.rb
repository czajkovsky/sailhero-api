FactoryGirl.define do
  factory :alert_down_confirmation, class: AlertConfirmation do
    up false
  end

  factory :alert_up_confirmation, class: AlertConfirmation do
    up true
  end
end
