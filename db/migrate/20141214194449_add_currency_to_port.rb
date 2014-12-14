class AddCurrencyToPort < ActiveRecord::Migration
  def change
    add_column :ports, :currency, :string, default: 'EUR'
  end
end
