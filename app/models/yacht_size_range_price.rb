class YachtSizeRangePrice < ActiveRecord::Base
  belongs_to :port
  default_scope { order('price') }

  validates :max_length, :min_length, :max_width,
            numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
