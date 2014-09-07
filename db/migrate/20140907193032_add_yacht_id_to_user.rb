class AddYachtIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :yacht_id, :integer
  end
end
