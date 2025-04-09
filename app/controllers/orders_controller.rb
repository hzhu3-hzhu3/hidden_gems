# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.customer.present?
      @orders = current_user.customer.orders.order(created_at: :desc)
    else
      redirect_to new_customer_path, notice: "请先创建您的客户资料"
    end
  end
  
  def show
    @order = current_user.customer.orders.find(params[:id])
  end
  
  def create
    unless current_user.customer.present?
      redirect_to new_customer_path, alert: "请先创建您的客户资料"
      return
    end
    
    if current_user.customer.addresses.empty?
      redirect_to new_address_path, alert: "请先添加送货地址"
      return
    end
    
    @order = current_user.customer.orders.new(order_params)
    @order.status = :pending
    @order.address = current_user.customer.addresses.first 
    
    subtotal = 0
    
    cart_empty = true
    (session[:cart] ||= {}).each do |product_id, qty|
      product = Product.find_by(id: product_id)
      next unless product
      
      current_price = product.current_price || 0
      subtotal += current_price * qty
      
      @order.order_items.build(
        product: product,
        quantity: qty,
        bought_price: current_price
      )
      
      cart_empty = false
    end
    
    if cart_empty
      redirect_to cart_show_path, alert: "您的购物车是空的"
      return
    end
    
    @order.total_price = subtotal
    
    if @order.save
      session[:cart] = {}
      redirect_to @order, notice: "订单已成功创建！"
    else
      redirect_to cart_show_path, alert: "创建订单失败，请重试。"
    end
  end
  
  private
  
  def order_params
    params.fetch(:order, {}).permit(:status, :address_id)
  end
end