class Training < ActiveRecord::Base
  belongs_to :user
  has_many :checkpoints

  scope :my, -> (user) { where(:user_id == user.id) }
  scope :newest, -> { order('created_at DESC') }
  scope :not_finished, -> { where(finished_at: nil) }
  scope :finished, -> { where.not(finished_at: nil) }
end
