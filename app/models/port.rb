class Port < ActiveRecord::Base
  has_many :yacht_size_range_prices
  belongs_to :region

  CURRENCIES = %w(EUR PLN USD CHF).freeze
  validates :currency, inclusion: { in: CURRENCIES }
  validates :name, :city, :street, length: { in: 2..128 }
end
