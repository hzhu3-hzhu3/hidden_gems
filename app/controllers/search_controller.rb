class SearchController < ApplicationController
  def index
    @query = params[:query]
    @category_id = params[:category_id]
    
    @products = Product.select("products.*")
    
    if @category_id.present? && @category_id != "all"
      @products = @products.joins(:product_categories)
                          .where(product_categories: { category_id: @category_id })
                          .distinct
    end
    
    if @query.present?
      @products = @products.where("products.name ILIKE :query OR products.description ILIKE :query", 
                                 query: "%#{@query}%")
    end
    
    @products = @products.includes(:product_prices)
    
    @products = @products.page(params[:page]).per(9)
    
    @breadcrumbs = [
      {name: "Home", path: root_path},
      {name: "Search Results", path: search_path(query: @query, category_id: @category_id)}
    ]

    @categories = Category.all
  end
end