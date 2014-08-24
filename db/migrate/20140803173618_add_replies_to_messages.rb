class AddRepliesToMessages < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :body
      t.belongs_to :user
      t.belongs_to :message
      t.timestamps
    end
  end
end
