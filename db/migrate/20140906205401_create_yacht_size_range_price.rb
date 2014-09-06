class CreateYachtSizeRangePrice < ActiveRecord::Migration
  def change
    drop_table :map_ports

    create_table :yacht_size_range_prices do |t|
      t.integer :min_length
      t.integer :max_length
      t.float :price
      t.timestamps
    end

    create_table :yacht_size_range_prices_ports do |t|
      t.belongs_to :port
      t.belongs_to :yacht_size_range_price
    end

    create_table :ports do |t|
      t.string :name
      t.float :longitude, default: 0
      t.float :latitude, default: 0
      t.timestamps
    end
  end
end
