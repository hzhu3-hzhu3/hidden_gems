class Product < ApplicationRecord
  has_many :product_prices, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  
  has_one_attached :photo do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 5 }
  
  scope :search_by_keyword, ->(query) { 
    where("products.name ILIKE :query OR products.description ILIKE :query", query: "%#{query}%") 
  }
  
  scope :filter_by_category, ->(category_id) { 
    joins(:product_categories)
      .where(product_categories: { category_id: category_id })
      .distinct 
  }
  def current_price
    product_prices.order(effective_date: :desc).first&.price
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["categories", "photo_attachment", "photo_blob", "product_categories", "product_prices"]
  end

end