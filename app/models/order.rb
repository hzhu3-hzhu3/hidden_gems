class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :address, optional: true
  has_many :order_items, dependent: :destroy
  
  enum :status, { pending: 0, paid: 1, shipped: 2, cancelled: 3 }
  
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
  
  def self.gst_rate_for_province(province)
    province = province.to_s.strip.downcase
    case province
    when "alberta", "northwest territories", "nunavut", "yukon"
      0.05
    when "british columbia", "manitoba", "saskatchewan", "quebec"
      0.05
    when "ontario"
      0.13 
    when "new brunswick", "newfoundland and labrador", "prince edward island"
      0.15 
    when "nova scotia"
      0.14
    else
      0.05 
    end
  end
  
  def self.pst_rate_for_province(province)
    province = province.to_s.strip.downcase
    case province
    when "alberta", "northwest territories", "nunavut", "yukon"
      0.00 
    when "british columbia", "manitoba"
      0.07
    when "saskatchewan"
      0.06
    when "quebec"
      0.09975 
    when "ontario", "new brunswick", "newfoundland and labrador", "nova scotia", "prince edward island"
      0.00 
    else
      0.07 
    end
  end

  def self.current_gst_rate
    0.05 
  end
  
  def self.current_pst_rate
    0.07 
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["address_id", "created_at", "customer_id", "id", "status", "gst_rate", "pst_rate", "total_price", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["address", "customer", "order_items"]
  end
end