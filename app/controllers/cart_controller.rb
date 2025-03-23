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
end
