class Customer < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :nullify
  has_many :addresses, dependent: :destroy
  
  validates :full_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "full_name", "id", "phone", "updated_at", "user_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["addresses", "orders", "user"]
  end
end
