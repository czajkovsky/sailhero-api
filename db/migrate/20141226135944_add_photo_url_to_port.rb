class AddPhotoUrlToPort < ActiveRecord::Migration
  def change
    add_column :ports, :photo_url, :string
  end
end
