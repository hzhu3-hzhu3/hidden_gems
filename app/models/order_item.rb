class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  validates :quantity, numericality: { greater_than: 0 }
  validates :bought_price, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_amount, numericality: { greater_than_or_equal_to: 0 }
  
  def subtotal
    quantity * bought_price
  end
  
  def tax_total
    gst_amount + pst_amount
  end
  
  def total
    subtotal + tax_total
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["bought_price", "created_at", "id", "order_id", "product_id", "quantity", "gst_amount", "pst_amount", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end
end