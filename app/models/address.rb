class Address < ApplicationRecord
  belongs_to :customer
  
  validates :street, :city, :province, :postal_code, presence: true
  
  def self.ransackable_attributes(auth_object = nil)
    ["city", "created_at", "customer_id", "id", "postal_code", "province", "street", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["customer"]
  end
  
  def full_address
    "#{street}, #{city}, #{province} #{postal_code}"
  end
end