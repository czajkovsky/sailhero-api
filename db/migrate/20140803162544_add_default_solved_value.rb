class AddDefaultSolvedValue < ActiveRecord::Migration
  def change
    remove_column :messages, :solved
    add_column :messages, :solved, :boolean, default: false
  end
end
