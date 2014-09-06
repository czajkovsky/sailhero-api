class CreateYachtModel < ActiveRecord::Migration
  def change
    create_table :yachts do |t|
      t.float :length, default: 7.0
      t.float :width, default: 2.5
    end
  end
end
