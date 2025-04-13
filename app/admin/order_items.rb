ActiveAdmin.register OrderItem do
  belongs_to :order
  navigation_menu :order
  
  permit_params :order_id, :product_id, :quantity, :bought_price, :gst_amount, :pst_amount
  
  index do
    selectable_column
    id_column
    column :order
    column :product
    column :quantity
    column :bought_price do |item|
      number_to_currency(item.bought_price)
    end
    column :subtotal do |item|
      number_to_currency(item.subtotal)
    end
    column :gst_amount do |item|
      number_to_currency(item.gst_amount)
    end
    column :pst_amount do |item|
      number_to_currency(item.pst_amount)
    end
    column :total do |item|
      number_to_currency(item.total)
    end
    actions
  end
  
  form do |f|
    f.inputs "Order Item Details" do
      f.input :order
      f.input :product
      f.input :quantity
      f.input :bought_price
      f.input :gst_amount
      f.input :pst_amount
    end
    f.actions
  end
end