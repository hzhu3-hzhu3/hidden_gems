class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :address, optional: true
  has_many :order_items, dependent: :destroy
  
  enum status: { pending: 0, paid: 1, shipped: 2, cancelled: 3 }
  
  validates :status, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  
  def self.ransackable_attributes(auth_object = nil)
    ["address_id", "created_at", "customer_id", "id", "status", "total_price", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["address", "customer", "order_items"]
  end
end