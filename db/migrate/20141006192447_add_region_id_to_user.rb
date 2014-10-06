class AddRegionIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :region_id, :integer
  end
end
