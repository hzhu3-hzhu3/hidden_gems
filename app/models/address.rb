class Address < ApplicationRecord
  belongs_to :customer
  
  validates :province, presence: true
  validates :street, :city, :postal_code, presence: true, if: -> { street.present? || city.present? || postal_code.present? }
  
  def self.ransackable_attributes(auth_object = nil)
    ["city", "created_at", "customer_id", "id", "postal_code", "province", "street", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["customer"]
  end
  
  def full_address
    if street.present? && city.present? && postal_code.present?
      "#{street}, #{city}, #{province} #{postal_code}"
    else
      "#{province}"
    end
  end
end