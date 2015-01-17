class UpdateRouteRelation < ActiveRecord::Migration
  def change
    change_column :routes, :region_id, :integer, null: false
  end
end
