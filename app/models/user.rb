class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.user_role ||= 0   # 0 = customer, 1 = admin
  end

  def admin?
    user_role == 1
  end

  def customer?
    user_role == 0
  end
end