class CartController < ApplicationController
  def show
    @items = []
    (session[:cart] || {}).each do |product_id, qty|
      product = Product.find_by(id: product_id)
      @items << { product: product, quantity: qty } if product
    end
  end
  

  def add
    session[:cart] ||= {}
    id = params[:id].to_s
    session[:cart][id] ||= 0
    session[:cart][id] += 1
    redirect_to cart_path
  end

  def update
    session[:cart] ||= {}
    product_id = params[:id].to_s
    new_qty = params[:quantity].to_i
  
    if new_qty <= 0
      session[:cart].delete(product_id)
    else
      session[:cart][product_id] = new_qty
    end
  
    redirect_to cart_path
  end
  
  def remove
    session[:cart] ||= {}
    session[:cart].delete(params[:id].to_s)
    redirect_to cart_path
  end
  
end
