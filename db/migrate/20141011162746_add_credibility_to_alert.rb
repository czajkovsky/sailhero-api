class AddCredibilityToAlert < ActiveRecord::Migration
  def change
    add_column :alerts, :credibility, :integer, default: 0
  end
end
