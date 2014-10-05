class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.datetime :started_at
      t.datetime :finished_at
      t.float :distance
      t.integer :user_id

      t.timestamps
    end
  end
end
