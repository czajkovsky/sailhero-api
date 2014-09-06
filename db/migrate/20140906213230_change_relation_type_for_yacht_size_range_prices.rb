class ChangeRelationTypeForYachtSizeRangePrices < ActiveRecord::Migration
  def change
    drop_table :ports_yacht_size_range_prices
    add_column :yacht_size_range_prices, :port_id, :integer
  end
end
