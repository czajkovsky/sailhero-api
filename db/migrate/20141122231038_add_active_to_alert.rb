class AddActiveToAlert < ActiveRecord::Migration
  def change
    add_column :alerts, :active, :boolean, default: true
  end
end
