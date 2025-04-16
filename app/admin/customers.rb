ActiveAdmin.register Customer do
  menu priority: 7, label: "Customers"
  
  permit_params :user_id, :full_name, :email, :phone
  
  index do
    selectable_column
    id_column
    column :full_name
    column :email
    column :phone
    column :orders_count do |customer|
      customer.orders.count
    end
    column :total_spent do |customer|
      number_to_currency(customer.orders.sum(:total_price))
    end
    column :created_at
    actions
  end

  show do
    columns do
      column span: 2 do
        panel "Customer Details" do
          attributes_table do
            row :id
            row :full_name
            row :email
            row :phone
            row :user
            row :created_at
            row :updated_at
          end
        end
        
        panel "Orders" do
          table_for customer.orders.order(created_at: :desc) do
            column :id do |order|
              link_to order.id, admin_order_path(order)
            end
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
          end
          
          div style: "margin-top: 15px; text-align: right;" do
            span "Total Orders: ", style: "font-weight: bold;"
            span customer.orders.count
            span " | "
            span "Total Spent: ", style: "font-weight: bold;"
            span number_to_currency(customer.orders.sum(:total_price))
          end
        end
      end
      
      column span: 1 do
        panel "Addresses" do
          table_for customer.addresses do
            column :street
            column :city
            column :province
            column :postal_code
            column :actions do |address|
              link_to "View", admin_address_path(address)
            end
          end
        end
      end
    end
  end
  
  form do |f|
    f.semantic_errors
    
    f.inputs "Customer Details" do
      f.input :user
      f.input :full_name
      f.input :email
      f.input :phone
    end
    
    f.actions
  end
end