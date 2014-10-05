class TrainingSerializer < ActiveModel::Serializer
  attributes :id, :started_at, :finished_at, :user_id, :distance
  has_many :checkpoints, embed: :ids, include: true
end
