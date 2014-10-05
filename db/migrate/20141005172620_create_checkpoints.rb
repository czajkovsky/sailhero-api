class CreateCheckpoints < ActiveRecord::Migration
  def change
    create_table :checkpoints do |t|
      t.float :longitude
      t.float :latitude
      t.integer :training_id
      t.string :type

      t.timestamps
    end
  end
end
