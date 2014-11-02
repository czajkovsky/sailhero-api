class CreateDevice < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_type
      t.string :name
      t.integer :token_id
      t.string :key
      t.integer :user_id

      t.timestamps
    end
  end
end
