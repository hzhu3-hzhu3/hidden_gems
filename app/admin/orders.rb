ActiveAdmin.register Order do
  permit_params :customer_id, :address_id, :status, :total_price, :gst_rate, :pst_rate
  
  scope :all
  scope :pending
  scope :paid
  scope :shipped
  scope :cancelled
  
  index do
    selectable_column
    id_column
    column :customer
    column :status do |order|
      status_tag order.status, 
        class: order.status == 'paid' ? :ok : 
               (order.status == 'pending' ? :warning : 
                (order.status == 'shipped' ? :yes : :error))
    end
    column :total_price do |order|
      number_to_currency(order.total_price)
    end
    column :created_at
    actions
  end
  
  show do
    attributes_table do
      row :id
      row :customer
      row :address
      row :status
      row :total_price do |order|
        number_to_currency(order.total_price)
      end
      row :gst_rate do |order|
        "#{(order.gst_rate * 100).round(2)}%"
      end
      row :pst_rate do |order|
        "#{(order.pst_rate * 100).round(2)}%"
      end
      row :created_at
      row :updated_at
    end
    
    panel "Order Items" do
      table_for order.order_items do
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
      end
    end
  end
  
  form do |f|
    f.inputs "Order Details" do
      f.input :customer
      f.input :address
      f.input :status, as: :select, collection: Order.statuses.keys.map { |s| [s.titleize, s] }
      f.input :total_price
      f.input :gst_rate
      f.input :pst_rate
    end
    f.actions
  end
  
  filter :customer
  filter :status, as: :select, collection: Order.statuses
  filter :total_price
  filter :created_at
end