class Province < ApplicationRecord
  has_many :addresses
  
  validates :name, presence: true, uniqueness: true
  validates :gst_rate, :pst_rate, numericality: { greater_than_or_equal_to: 0 }
  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst_rate", "has_hst", "id", "name", "pst_rate", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["addresses"]
  end
  
  def display_name
    has_hst ? "#{name} (HST: #{(gst_rate * 100).round(2)}%)" : 
              "#{name} (GST: #{(gst_rate * 100).round(2)}%, PST: #{(pst_rate * 100).round(2)}%)"
  end
end