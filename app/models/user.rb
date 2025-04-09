class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one :customer, dependent: :destroy
  validates :username, presence: true
  
  after_initialize :set_default_role, if: :new_record?
  
  def set_default_role
    self.role ||= 0 # 0 = customer, 1 = admin
  end
  
  def admin?
    role == 1
  end
  
  def customer?
    role == 0
  end
  
end