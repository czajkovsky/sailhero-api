class UpdateYachtSizeRangePricesRelation < ActiveRecord::Migration
  def change
    change_column :yacht_size_range_prices, :min_length, :integer, default: 0
    change_column :yacht_size_range_prices, :max_length, :integer, default: 2000
    remove_column :yacht_size_range_prices, :updated_at
    remove_column :yacht_size_range_prices, :created_at
    change_column :yacht_size_range_prices, :port_id, :integer, null: false
  end
end
