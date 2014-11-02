class CreateGcm < ActiveRecord::Migration
  def change
    create_table :gcms do |t|
      t.integer :token_id
      t.string :key

      t.timestamps
    end
  end
end
