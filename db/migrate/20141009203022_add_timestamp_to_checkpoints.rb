class AddTimestampToCheckpoints < ActiveRecord::Migration
  def change
    add_column :checkpoints, :timestamp, :datetime
  end
end
