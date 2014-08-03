class AddNameAndSurnameToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, default: ''
    add_column :users, :surname, :string, default: ''
  end
end
