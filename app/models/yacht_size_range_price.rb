class YachtSizeRangePrice < ActiveRecord::Base
  belongs_to :port
  default_scope { order('price') }
end
