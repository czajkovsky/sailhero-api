class AddDefaultPriceToYachtSizeRangePrices < ActiveRecord::Migration
  def change
    change_column :yacht_size_range_prices, :price, :integer, default: 0.0
  end
end
