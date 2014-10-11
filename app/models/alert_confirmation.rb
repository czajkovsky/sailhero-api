class AlertConfirmation < ActiveRecord::Base
  belongs_to :user
  belongs_to :alert
end
