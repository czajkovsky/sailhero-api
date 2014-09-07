class RemoveYachtIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :yacht_id
  end
end
