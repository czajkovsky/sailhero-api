class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :full_name
      t.string :code_name

      t.timestamps
    end
  end
end
