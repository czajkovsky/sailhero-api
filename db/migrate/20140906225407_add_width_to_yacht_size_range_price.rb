class AddWidthToYachtSizeRangePrice < ActiveRecord::Migration
  def change
    add_column :yacht_size_range_prices, :max_width, :float, default: 100.0
  end
end
