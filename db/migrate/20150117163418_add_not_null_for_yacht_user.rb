class AddNotNullForYachtUser < ActiveRecord::Migration
  def change
    change_column :yachts, :user_id, :integer, null: false
    change_column :yachts, :crew, :integer, default: 4
  end
end
