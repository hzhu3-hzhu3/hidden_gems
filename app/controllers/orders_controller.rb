class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, except: [:index, :show]
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
    
    @order = current_user.customer.orders.new
    @address = current_user.customer.addresses.first || Address.new
    @provinces = get_provinces_with_taxes
    
    calculate_cart_preview
  end

  def create
    unless current_user.customer.present?
      redirect_to new_customer_path, alert: "Please create your customer profile first"
      return
    end

    if session[:cart].blank? || session[:cart].empty?
      redirect_to cart_show_path, alert: "Your cart is empty"
      return
    end

    if address_params[:id].present?
      @address = current_user.customer.addresses.find(address_params[:id])
    else
      @address = current_user.customer.addresses.build(
        street: address_params[:street],
        city: address_params[:city],
        province: address_params[:province],
        postal_code: address_params[:postal_code]
      )
      
      unless @address.save
        flash.now[:alert] = "Could not save address: #{@address.errors.full_messages.join(', ')}"
        redirect_to new_order_path, status: :unprocessable_entity
        return
      end
    end

    @order = current_user.customer.orders.new
    @order.status = :pending
    @order.address = @address
    

    set_tax_rates_for_province(@address.province)
    
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
      redirect_to @order, notice: "Order successfully placed!"
    else
      redirect_to new_order_path, alert: "Failed to create order: #{@order.errors.full_messages.join(', ')}"
    end
  end

  private
  
  def set_customer
    unless current_user.customer.present?
      redirect_to new_customer_path, alert: "Please create your customer profile first"
    end
  end
  
  def set_order
    @order = Order.find(params[:id])
  end
  
  def address_params
    params.require(:address).permit(:id, :street, :city, :province, :postal_code)
  end
  
  def set_tax_rates_for_province(province)
    @order.gst_rate = Order.gst_rate_for_province(province)
    @order.pst_rate = Order.pst_rate_for_province(province)
  end
  
  def get_provinces_with_taxes
    [
      { name: 'Alberta', gst: 5, pst: 0 },
      { name: 'British Columbia', gst: 5, pst: 7 },
      { name: 'Manitoba', gst: 5, pst: 7 },
      { name: 'New Brunswick', gst: 15, pst: 0 },
      { name: 'Newfoundland and Labrador', gst: 15, pst: 0 },
      { name: 'Northwest Territories', gst: 5, pst: 0 },
      { name: 'Nova Scotia', gst: 14, pst: 0 },
      { name: 'Nunavut', gst: 5, pst: 0 },
      { name: 'Ontario', gst: 13, pst: 0 },
      { name: 'Prince Edward Island', gst: 15, pst: 0 },
      { name: 'Quebec', gst: 5, pst: 9.975 },
      { name: 'Saskatchewan', gst: 5, pst: 6 },
      { name: 'Yukon', gst: 5, pst: 0 }
    ]
  end
  
  def calculate_cart_preview
    @items = []
    @subtotal = 0
    @gst_rate = 0.05
    @pst_rate = 0.07
    
    if params[:address_id].present? && (address = current_user.customer.addresses.find_by(id: params[:address_id]))
      set_tax_rates_for_province(address.province)
    elsif params[:province].present?
      set_tax_rates_for_province(params[:province])
    end
    
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