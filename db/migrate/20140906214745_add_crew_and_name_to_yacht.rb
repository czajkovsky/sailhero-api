class AddCrewAndNameToYacht < ActiveRecord::Migration
  def change
    add_column :yachts, :crew, :integer
    add_column :yachts, :name, :string
  end
end
