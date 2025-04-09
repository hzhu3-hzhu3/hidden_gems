class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :address, optional: true
  has_many :order_items, dependent: :destroy
  
  enum status: { pending: 0, paid: 1, shipped: 2, cancelled: 3 }
  
  validates :status, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_rate, numericality: { greater_than_or_equal_to: 0 }
  
  def subtotal
    order_items.sum { |item| item.quantity * item.bought_price }
  end
  
  def total_gst
    order_items.sum(&:gst_amount)
  end
  
  def total_pst
    order_items.sum(&:pst_amount)
  end
  
  def total_tax
    total_gst + total_pst
  end
  
  def self.current_gst_rate
    0.05 # 5% GST
  end
  
  def self.current_pst_rate
    0.07 # 7% PST
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["address_id", "created_at", "customer_id", "id", "status", "gst_rate", "pst_rate", "total_price", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["address", "customer", "order_items"]
  end
end