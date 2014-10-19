class ChangeYachtSizeRangePricesType < ActiveRecord::Migration
  def up
    change_column :yacht_size_range_prices, :max_width, :integer, default: 100
  end

  def down
    change_column :yacht_size_range_prices, :max_width, :float
  end
end
