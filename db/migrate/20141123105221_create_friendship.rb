class CreateFriendship < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :status

      t.timestamps
    end
  end
end
