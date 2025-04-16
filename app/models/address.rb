class Address < ApplicationRecord
  belongs_to :customer
  belongs_to :province
  
  validates :province_id, presence: true
  validates :street, :city, :postal_code, presence: true, if: -> { street.present? || city.present? || postal_code.present? }
  
  def self.ransackable_attributes(auth_object = nil)
    ["city", "created_at", "customer_id", "id", "postal_code", "province_id", "street", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["customer", "province"]
  end
  
  def full_address
    if street.present? && city.present? && postal_code.present?
      "#{street}, #{city}, #{province.name} #{postal_code}"
    else
      province&.name || "Unknown Province"
    end
  end
  
  def province_name
    province&.name
  end
end