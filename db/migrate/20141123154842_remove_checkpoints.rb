class RemoveCheckpoints < ActiveRecord::Migration
  def change
    drop_table :checkpoints
    drop_table :messages
    drop_table :replies
    drop_table :trainings
  end
end
