ActiveAdmin.register Order do
  menu priority: 3
  
  permit_params :customer_id, :address_id, :status, :total_price, :gst_rate, :pst_rate
  
  scope :all, default: true
  scope :pending do |orders|
    orders.where(status: :pending)
  end
  scope :paid do |orders|
    orders.where(status: :paid)
  end
  scope :shipped do |orders|
    orders.where(status: :shipped)
  end
  scope :cancelled do |orders|
    orders.where(status: :cancelled)
  end
  
  filter :id
  filter :customer
  filter :total_price
  filter :created_at
  filter :status, as: :select, collection: Order.statuses
  
  index do
    selectable_column
    id_column
    column :customer do |order|
      link_to order.customer.full_name, admin_customer_path(order.customer)
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
    column :items do |order|
      "#{order.order_items.sum(:quantity)} items"
    end
    column :created_at
    actions
  end
  
  action_item :view_orders_details, only: :index do
    link_to 'Order Details View', orders_details_admin_orders_path
  end
  
  collection_action :orders_details, method: :get do
    @orders = Order.includes(:customer, :order_items, :address, order_items: :product)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(10)
  end
  
  show do
    columns do
      column span: 2 do
        panel "Order Details" do
          attributes_table do
            row :id
            row :customer do |order|
              link_to order.customer.full_name, admin_customer_path(order.customer)
            end
            row :address
            row :status do |order|
              status_tag order.status,
                class: order.status == 'paid' ? :ok :
                       (order.status == 'pending' ? :warning :
                       (order.status == 'shipped' ? :yes : :error))
            end
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
            if order.stripe_payment_id.present?
              row :stripe_payment_id
            end
          end
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
          
          div class: "order-totals", style: "margin-top: 15px; text-align: right;" do
            div do
              span "Subtotal: ", style: "font-weight: bold;"
              span number_to_currency(order.subtotal)
            end
            div do
              span "GST/HST: ", style: "font-weight: bold;"
              span number_to_currency(order.total_gst)
            end
            div do
              span "PST: ", style: "font-weight: bold;"
              span number_to_currency(order.total_pst)
            end
            div style: "font-size: 1.2em; margin-top:
                        div style: "font-size: 1.2em; margin-top: 5px;" do
              span "Total: ", style: "font-weight: bold;"
              span number_to_currency(order.total_price), style: "color: #198754; font-weight: bold;"
            end
          end
        end
      end
      
      column span: 1 do
        panel "Change Status" do
          div class: "status-form" do
            semantic_form_for [:admin, order], url: admin_order_path(order) do |f|
              f.inputs do
                f.input :status, as: :select, collection: Order.statuses.keys.map { |s| [s.titleize, s] }
              end
              f.actions do
                f.action :submit, label: "Update Status"
              end
            end
          end
        end
        
        panel "Customer Information" do
          attributes_table_for order.customer do
            row :full_name
            row :email
            row :phone
          end
        end
        
        panel "Shipping Address" do
          attributes_table_for order.address do
            row :street
            row :city
            row :province
            row :postal_code
          end
        end
      end
    end
  end
  
  # New and Edit forms
  form do |f|
    f.semantic_errors
    
    f.inputs "Order Details" do
      f.input :customer
      f.input :address, collection: Address.all.map { |a| [a.full_address, a.id] }
      f.input :status, as: :select, collection: Order.statuses.keys.map { |s| [s.titleize, s] }
      
      unless f.object.new_record?
        f.input :total_price, input_html: { disabled: true }
        f.input :gst_rate, input_html: { step: 0.01 }
        f.input :pst_rate, input_html: { step: 0.01 }
      end
    end
    
    f.actions
  end

  controller do
    def update
      @order = Order.find(params[:id])
      old_status = @order.status
      
      if @order.update(permitted_params[:order])
        if old_status != @order.status
          ActiveAdmin::Comment.create(
            resource_type: "Order",
            resource_id: @order.id,
            body: "Status changed from #{old_status} to #{@order.status}",
            namespace: "admin",
            author_type: "AdminUser",
            author_id: current_admin_user.id
          )
        end
        
        redirect_to admin_order_path(@order), notice: "Order was successfully updated."
      else
        render :edit
      end
    end
  end
end