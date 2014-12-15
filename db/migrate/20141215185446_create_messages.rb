class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.decimal :latitude
      t.decimal :longitude
      t.text :body

      t.timestamps
    end
  end
end
