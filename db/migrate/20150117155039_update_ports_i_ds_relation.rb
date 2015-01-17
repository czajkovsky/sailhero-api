class UpdatePortsIDsRelation < ActiveRecord::Migration
  def change
    change_column :ports, :region_id, :integer, null: false
  end
end
