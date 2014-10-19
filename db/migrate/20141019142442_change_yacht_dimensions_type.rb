class ChangeYachtDimensionsType < ActiveRecord::Migration
  def up
    change_column :yachts, :length, :integer, default: 700
    change_column :yachts, :width, :integer, default: 200
  end

  def down
    change_column :yachts, :length, :float
    change_column :yachts, :width, :float
  end
end
