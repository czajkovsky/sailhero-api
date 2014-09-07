class AddUserIdToYacht < ActiveRecord::Migration
  def change
    add_column :yachts, :user_id, :integer
  end
end
