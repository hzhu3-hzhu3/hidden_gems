# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

OrderItem.delete_all
Order.delete_all
Address.delete_all
Customer.delete_all
User.delete_all
AdminUser.delete_all
ProductPrice.delete_all
ProductCategory.delete_all
Product.delete_all
Category.delete_all

User.create!(
  username: 'user1',
  email: 'gloriazhu10@outlook.com',
  password: 'password',
  password_confirmation: 'password',
  role: 0
)

AdminUser.create!(
  email: "hzhu3@rrc.ca",
  password: "password",
  password_confirmation: "password"
) if Rails.env.development?

category_names = ["Electronics", "Books", "Kitchen", "Sports"]
categories = category_names.map { |name| Category.find_or_create_by!(name: name) }

unique_count = 0
while unique_count < 100
  name = Faker::Commerce.product_name
  unless Product.exists?(name: name)
    product = Product.create!(
      name: name,
      description: "#{Faker::Commerce.material} #{Faker::Marketing.buzzwords}"
    )

    ProductCategory.create!(
      product: product,
      category: categories.sample
    )

    ProductPrice.create!(
      product: product,
      price: Faker::Commerce.price(range: 5..200),
      effective_date: Faker::Date.backward(days: 30)
    )

    unique_count += 1
  end

  provinces_data = [
  { name: 'Alberta', gst_rate: 0.05, pst_rate: 0.00, has_hst: false },
  { name: 'British Columbia', gst_rate: 0.05, pst_rate: 0.07, has_hst: false },
  { name: 'Manitoba', gst_rate: 0.05, pst_rate: 0.07, has_hst: false },
  { name: 'New Brunswick', gst_rate: 0.15, pst_rate: 0.00, has_hst: true },
  { name: 'Newfoundland and Labrador', gst_rate: 0.15, pst_rate: 0.00, has_hst: true },
  { name: 'Northwest Territories', gst_rate: 0.05, pst_rate: 0.00, has_hst: false },
  { name: 'Nova Scotia', gst_rate: 0.14, pst_rate: 0.00, has_hst: true },
  { name: 'Nunavut', gst_rate: 0.05, pst_rate: 0.00, has_hst: false },
  { name: 'Ontario', gst_rate: 0.13, pst_rate: 0.00, has_hst: true },
  { name: 'Prince Edward Island', gst_rate: 0.15, pst_rate: 0.00, has_hst: true },
  { name: 'Quebec', gst_rate: 0.05, pst_rate: 0.09975, has_hst: false },
  { name: 'Saskatchewan', gst_rate: 0.05, pst_rate: 0.06, has_hst: false },
  { name: 'Yukon', gst_rate: 0.05, pst_rate: 0.00, has_hst: false }
]

  provinces_data.each do |province_data|
    Province.find_or_create_by!(name: province_data[:name]) do |province|
      province.gst_rate = province_data[:gst_rate]
      province.pst_rate = province_data[:pst_rate]
      province.has_hst = province_data[:has_hst]
    end
  end
end
