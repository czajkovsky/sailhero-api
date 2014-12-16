class AddSharePositionToUser < ActiveRecord::Migration
  def change
    add_column :users, :share_position, :boolean, default: true
  end
end
