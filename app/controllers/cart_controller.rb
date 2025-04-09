class CartController < ApplicationController
  def show
    @items = []
    @total = 0
    (session[:cart] ||= {}).each do |product_id, qty|
      product = Product.find_by(id: product_id)
      if product
        price = product.current_price || 0
        item_total = price * qty
        @total += item_total
        @items << { product: product, quantity: qty, total: item_total }
      end
    end
  end

  def add
    session[:cart] ||= {}
    id = params[:id].to_s
    session[:cart][id] ||= 0
    session[:cart][id] += 1
    redirect_to cart_show_path, notice: "Product added to cart."
  end

  def update
    session[:cart] ||= {}
    product_id = params[:id].to_s
    new_qty = params[:quantity].to_i
    
    if new_qty <= 0
      session[:cart].delete(product_id)
      notice = "Product removed from cart."
    else
      session[:cart][product_id] = new_qty
      notice = "Cart updated successfully."
    end
    
    redirect_to cart_show_path, notice: notice
  end

  def remove
    session[:cart] ||= {}
    session[:cart].delete(params[:id].to_s)
    redirect_to cart_show_path, notice: "Product removed from cart."
  end

  def cart_count
    (session[:cart] || {}).values.sum
  end
  helper_method :cart_count
end