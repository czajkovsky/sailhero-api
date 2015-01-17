class UpdateMessagesRelation < ActiveRecord::Migration
  def change
    change_column :messages, :user_id, :integer, null: false
    change_column :messages, :region_id, :integer, null: false
    remove_column :messages, :updated_at
  end
end
