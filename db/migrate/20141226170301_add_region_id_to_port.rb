class AddRegionIdToPort < ActiveRecord::Migration
  def change
    add_column :ports, :region_id, :integer
  end
end
