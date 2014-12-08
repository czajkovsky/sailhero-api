class AddOuathTokenToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :outh_token, :string
  end
end
