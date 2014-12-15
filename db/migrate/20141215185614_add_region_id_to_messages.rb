class AddRegionIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :region_id, :integer
  end
end
