class AddRegionIdToAlert < ActiveRecord::Migration
  def change
    add_column :alerts, :region_id, :integer
  end
end
