class AlertConfirmation < ActiveRecord::Base
  belongs_to :user
  belongs_to :alert

  validates :up, presence: true
end
