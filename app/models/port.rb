class Port < ActiveRecord::Base
  has_many :yacht_size_range_prices
  belongs_to :region
end
