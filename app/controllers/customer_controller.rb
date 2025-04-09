class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update]
  
  def show
  end
  
  def new
    if current_user.customer.present?
      redirect_to customer_path(current_user.customer), notice: "You already have a customer profile"
      return
    end
    @customer = Customer.new
  end
  
  def create
    if current_user.customer.present?
      redirect_to customer_path(current_user.customer), notice: "You already have a customer profile"
      return
    end
    
    @customer = current_user.build_customer(customer_params)
    
    if @customer.save
      redirect_to customer_path(@customer), notice: "Customer profile created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @customer.update(customer_params)
      redirect_to customer_path(@customer), notice: "Customer profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_customer
    @customer = current_user.customer
    unless @customer
      redirect_to new_customer_path, alert: "Please create your customer profile first"
    end
  end
  
  def customer_params
    params.require(:customer).permit(:full_name, :email, :phone)
  end
end