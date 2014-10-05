class AddPositionUpdatedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :position_updated_at, :datetime
  end
end
