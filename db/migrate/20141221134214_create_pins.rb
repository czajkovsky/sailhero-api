class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.integer :route_id
      t.decimal :latitude
      t.decimal :longitude
      t.timestamps
    end
  end
end
