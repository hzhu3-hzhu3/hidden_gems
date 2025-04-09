class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  protect_from_forgery with: :exception
  
  before_action :set_cart_count

  private

  def set_cart_count
    @cart_count = session[:cart].present? ? session[:cart].size : 0
  end
end
