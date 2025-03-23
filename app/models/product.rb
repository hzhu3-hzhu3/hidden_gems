class Product < ApplicationRecord
  has_many :product_prices
  has_many :product_categories
  has_many :categories, through: :product_categories

  has_one_attached :photo

  def current_price
    product_prices.order(effective_date: :desc).first&.price
  end
end
