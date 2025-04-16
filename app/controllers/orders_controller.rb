class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_minimum_customer_info, except: [:index, :show]
  before_action :set_order, only: [:show]
  
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
  
  def new
    if session[:cart].blank? || session[:cart].empty?
      redirect_to cart_show_path, alert: "Your cart is empty"
      return
    end
    
    @provinces = Province.all
    @addresses = current_user.customer.addresses if current_user.customer.present?
  end
  
  def review
    if session[:cart].blank? || session[:cart].empty?
      redirect_to cart_show_path, alert: "Your cart is empty"
      return
    end
    
    if params[:use_new_address] == "1"
      if params[:address][:province_id].blank?
        redirect_to new_order_path, alert: "Please select at least a province"
        return
      end
      
      province = Province.find(params[:address][:province_id])
      @address = Address.new(
        street: params[:address][:street],
        city: params[:address][:city],
        province_id: params[:address][:province_id],
        postal_code: params[:address][:postal_code]
      )
      @new_address = true
    elsif params[:address_id].present?
      @address = current_user.customer.addresses.find(params[:address_id])
      @new_address = false
    else
      redirect_to new_order_path, alert: "Please select or enter a shipping address"
      return
    end
    
    calculate_cart_preview(@address.province_id)
    
    session[:order_address] = {
      id: @new_address ? nil : @address.id,
      street: @address.street,
      city: @address.city,
      province_id: @address.province_id,
      postal_code: @address.postal_code,
      new_address: @new_address
    }
  end
  
  def create
    if session[:cart].blank? || session[:cart].empty?
      redirect_to cart_show_path, alert: "Your cart is empty"
      return
    end
    
    if session[:order_address].blank?
      redirect_to new_order_path, alert: "Please select a shipping address"
      return
    end
    
    address_info = session[:order_address]
    
    unless current_user.customer.present?
      @customer = current_user.create_customer(
        full_name: current_user.username,
        email: current_user.email
      )
    else
      @customer = current_user.customer
    end
    
    if address_info["new_address"] == true
      @address = @customer.addresses.create(
        street: address_info["street"],
        city: address_info["city"],
        province_id: address_info["province_id"],
        postal_code: address_info["postal_code"]
      )
      
      unless @address.persisted?
        redirect_to new_order_path, alert: "Could not save address: #{@address.errors.full_messages.join(', ')}"
        return
      end
    else
      @address = @customer.addresses.find(address_info["id"])
    end
    
    @order = @customer.orders.new
    @order.status = :pending
    @order.address = @address
    
    set_tax_rates_for_province(@address.province_id)
    
    total_before_tax = 0
    
    session[:cart].each do |product_id, qty|
      product = Product.find_by(id: product_id)
      next unless product
      
      current_price = product.current_price || 0
      item_subtotal = current_price * qty.to_i
      total_before_tax += item_subtotal
      
      gst_amount = item_subtotal * @order.gst_rate
      pst_amount = item_subtotal * @order.pst_rate
      
      @order.order_items.build(
        product: product,
        quantity: qty,
        bought_price: current_price,
        gst_amount: gst_amount,
        pst_amount: pst_amount
      )
    end
    
    @order.total_price = total_before_tax + (total_before_tax * (@order.gst_rate + @order.pst_rate))
    
    if @order.save
      session[:cart] = {}
      session[:order_address] = nil
      redirect_to @order, notice: "Order successfully placed!"
    else
      redirect_to new_order_path, alert: "Failed to create order: #{@order.errors.full_messages.join(', ')}"
    end
  end
  
  private
  
  def ensure_minimum_customer_info

  end
  
  def set_order
    @order = Order.find(params[:id])
  end
  
  def address_params
    params.require(:address).permit(:id, :street, :city, :province_id, :postal_code)
  end
  
  def set_tax_rates_for_province(province_id)
    province = Province.find(province_id)
    @order.gst_rate = province.gst_rate
    @order.pst_rate = province.pst_rate
  end
  
  def calculate_cart_preview(province_id)
    province = Province.find(province_id)
    @items = []
    @subtotal = 0
    @gst_rate = province.gst_rate
    @pst_rate = province.pst_rate
    
    session[:cart].each do |product_id, qty|
      product = Product.find_by(id: product_id)
      next unless product
      
      price = product.current_price || 0
      item_subtotal = price * qty.to_i
      
      @subtotal += item_subtotal
      
      gst_amount = item_subtotal * @gst_rate
      pst_amount = item_subtotal * @pst_rate
      
      @items << {
        product: product,
        quantity: qty.to_i,
        price: price,
        subtotal: item_subtotal,
        gst_amount: gst_amount,
        pst_amount: pst_amount,
        total: item_subtotal + gst_amount + pst_amount
      }
    end
    
    @gst_total = @subtotal * @gst_rate
    @pst_total = @subtotal * @pst_rate
    @total = @subtotal + @gst_total + @pst_total
  end
end