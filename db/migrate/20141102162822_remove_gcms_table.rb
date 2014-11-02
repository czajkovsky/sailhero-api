class RemoveGcmsTable < ActiveRecord::Migration
  def change
    drop_table :gcms
  end
end
