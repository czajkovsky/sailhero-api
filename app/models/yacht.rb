class Yacht < ActiveRecord::Base
  belongs_to :user

  validates :length, :width, :crew, numericality: { only_integer: true }
  validates :length, numericality: { greater_than: 300, less_than: 4000 }
  validates :width, numericality: { greater_than: 100, less_than: 1500 }
  validates :crew, numericality: { greater_than: 1, less_than: 30 }
  validates :name, length: { in: 4..128 }
end
