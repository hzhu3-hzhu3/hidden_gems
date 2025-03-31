class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_admin, except: [:index, :show]

  def index
    @products = Product.page(params[:page]).per(1)
  end
  

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
  
    respond_to do |format|
      if @product.save
        ProductPrice.create!(
          product: @product,
          price: params[:initial_price],
          effective_date: Time.current
        )
  
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_product
      @product = Product.find(params.expect(:id))
    end


    def product_params
      params.require(:product).permit(:name, :description, :photo, category_ids: [])
    end
    

    def check_admin
      redirect_to root_path, alert: "Access denied" unless current_user&.admin?
    end

end
