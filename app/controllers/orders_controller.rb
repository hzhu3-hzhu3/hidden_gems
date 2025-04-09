class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.customer.present?
      @orders = current_user.customer.orders.order(created_at: :desc)
    else
      redirect_to new_customer_path, notice: "Please create your customer profile first"
    end
  end
  
  def show
    @order = current_user.customer.orders.find(params[:id])
  end
  
  def create
    unless current_user.customer.present?
      redirect_to new_customer_path, alert: "Please create your customer profile first"
      return
    end
    
    if current_user.customer.addresses.empty?
      redirect_to new_address_path, alert: "Please add a shipping address first"
      return
    end
    
    @order = current_user.customer.orders.new(order_params)
    @order.status = :pending
    @order.address = current_user.customer.addresses.first
    
    current_gst_rate = Order.current_gst_rate
    current_pst_rate = Order.current_pst_rate
    @order.gst_rate = current_gst_rate
    @order.pst_rate = current_pst_rate
    
    subtotal = 0
    
    cart_empty = true
    (session[:cart] ||= {}).each do |product_id, qty|
      product = Product.find_by(id: product_id)
      next unless product
      
      current_price = product.current_price || 0
      item_subtotal = current_price * qty
      subtotal += item_subtotal
      
      gst_amount = item_subtotal * current_gst_rate
      pst_amount = item_subtotal * current_pst_rate
      
      @order.order_items.build(
        product: product,
        quantity: qty,
        bought_price: current_price,
        gst_amount: gst_amount,
        pst_amount: pst_amount
      )
      
      cart_empty = false
    end
    
    if cart_empty
      redirect_to cart_show_path, alert: "Your cart is empty"
      return
    end
    
    @order.total_price = subtotal * (1 + current_gst_rate + current_pst_rate)
    
    if @order.save
      session[:cart] = {}
      redirect_to @order, notice: "Order created successfully!"
    else
      redirect_to cart_show_path, alert: "Failed to create order. Please try again."
    end
  end
  
  private
  
  def order_params
    params.fetch(:order, {}).permit(:status, :address_id)
  end
end