class Port < ActiveRecord::Base
  has_many :yacht_size_range_prices
  belongs_to :region

  CURRENCIES = %w(EUR PLN USD CHF).freeze
  validates :currency, inclusion: { in: CURRENCIES }
  validates :name, :city, :street, length: { in: 2..128 }
  validates :spots, numericality: { greater_than_or_equal_to: 0,
                                    only_integer: true }
end
