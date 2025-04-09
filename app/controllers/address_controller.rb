# app/controllers/addresses_controller.rb
class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  
  def index
    @addresses = current_user.customer.addresses
  end
  
  def show
  end
  
  def new
    @address = current_user.customer.addresses.build
  end
  
  def create
    @address = current_user.customer.addresses.build(address_params)
    
    if @address.save
      redirect_to addresses_path, notice: "Address added successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @address.update(address_params)
      redirect_to addresses_path, notice: "Address updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @address.destroy
    redirect_to addresses_path, notice: "Address has been deleted", status: :see_other
  end
  
  private
  
  def ensure_customer
    unless current_user.customer.present?
      redirect_to new_customer_path, alert: "Please create your customer profile first"
    end
  end
  
  def set_address
    @address = current_user.customer.addresses.find(params[:id])
  end
  
  def address_params
    params.require(:address).permit(:street, :city, :province, :postal_code)
  end
end