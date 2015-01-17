class UpdatePinsRelation < ActiveRecord::Migration
  def change
    change_column :pins, :route_id, :integer, null: false
    remove_column :pins, :created_at
    remove_column :pins, :updated_at
  end
end
