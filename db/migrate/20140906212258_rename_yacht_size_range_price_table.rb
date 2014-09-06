class RenameYachtSizeRangePriceTable < ActiveRecord::Migration
  def change
    drop_table :yacht_size_range_prices_ports
    create_table :ports_yacht_size_range_prices do |t|
      t.belongs_to :port
      t.belongs_to :yacht_size_range_price
    end
  end
end
