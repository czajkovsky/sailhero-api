class RemoveOuathTokenFromDevice < ActiveRecord::Migration
  def change
    remove_column :devices, :outh_token, :string
  end
end
