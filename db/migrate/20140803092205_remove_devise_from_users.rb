class RemoveDeviseFromUsers < ActiveRecord::Migration
  def change
    drop_table :users
    create_table :users
    change_table(:users) do |t|
      t.string :email,         null: false, default: ''
      t.string :password_hash, null: false, default: ''
      t.string :password_salt, null: false, default: ''
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
