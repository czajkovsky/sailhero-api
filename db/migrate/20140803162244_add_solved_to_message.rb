class AddSolvedToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :solved, :boolean
  end
end
