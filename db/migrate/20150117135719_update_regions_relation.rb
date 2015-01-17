class UpdateRegionsRelation < ActiveRecord::Migration
  def change
    remove_column :regions, :created_at
    remove_column :regions, :updated_at
  end
end
