class UpdatePortsRelation < ActiveRecord::Migration
  def change
    change_column :messages, :region_id, :integer, null: false
  end
end
