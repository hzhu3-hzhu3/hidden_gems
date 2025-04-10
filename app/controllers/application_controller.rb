class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  protect_from_forgery with: :exception
  
  before_action :set_cart_count
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def set_cart_count
    @cart_count = session[:cart].present? ? session[:cart].size : 0
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
