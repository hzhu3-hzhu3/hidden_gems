ActiveAdmin.register Product do
  menu priority: 2, label: "Products"
  
  permit_params :name, :description, :photo, category_ids: []
  
  filter :name
  filter :description
  filter :categories
  filter :created_at
  filter :updated_at
  
  scope :all, default: true
  scope :new_products do |products|
    products.where('created_at >= ?', 3.days.ago)
  end
  scope :recently_updated do |products|
    products.where('updated_at > created_at AND updated_at >= ?', 3.days.ago)
  end
  
  index do
    selectable_column
    id_column
    column :name
    column :categories do |product|
      product.categories.map(&:name).join(", ")
    end
    column :current_price do |product|
      number_to_currency(product.current_price)
    end
    column :photo do |product|
      if product.photo.attached?
        image_tag url_for(product.photo.variant(:thumb)), style: "max-width: 100px; max-height: 100px;"
      else
        status_tag("No Image", class: "warning")
      end
    end
    column :updated_at
    actions
  end
  
  show do
    columns do
      column span: 2 do
        panel "Product Details" do
          attributes_table do
            row :id
            row :name
            row :description do |product|
              div class: "product-description" do
                product.description.html_safe
              end
            end
            row :categories do |product|
              product.categories.map(&:name).join(", ")
            end
            row :current_price do |product|
              number_to_currency(product.current_price)
            end
            row :created_at
            row :updated_at
          end
        end
      end
      
      column span: 1 do
        panel "Product Image" do
          if product.photo.attached?
            div class: "product-image text-center" do
              image_tag url_for(product.photo), style: "max-width: 100%; max-height: 300px;"
            end
          else
            div class: "no-image text-center" do
              span class: "placeholder", style: "display: block; width: 100%; height: 200px; background-color: #f8f9fa; display: flex; align-items: center; justify-content: center;" do
                "No image uploaded"
              end
            end
          end
        end
        
        panel "Quick Actions" do
          div class: "buttons" do
            span do
              link_to "View on Site", product_path(product), class: "button", target: "_blank"
            end
            span style: "margin-left: 10px;" do
              link_to "Edit", edit_admin_product_path(product), class: "button"
            end
          end
        end
      end
    end
    
    panel "Price History" do
      table_for product.product_prices.order(effective_date: :desc) do
        column :price do |pp|
          number_to_currency(pp.price)
        end
        column :effective_date
        column :created_at
      end
      
      div class: "add-price-form", style: "margin-top: 15px;" do
        render partial: "admin/products/price_form", locals: { product: product }
      end
    end
  end
  
  form html: { multipart: true } do |f|
    f.semantic_errors
    
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :photo, as: :file, hint: f.object.photo.attached? ? 
        image_tag(url_for(f.object.photo.variant(:thumb)), style: "max-width: 100px; max-height: 100px;") : 
        content_tag(:span, "No image yet")
      f.input :categories, as: :check_boxes, collection: Category.all
    end
    
    f.inputs "Pricing" do
      if f.object.new_record?
        f.has_many :product_prices, new_record: true, allow_destroy: false do |price|
          price.input :price
          price.input :effective_date, as: :date_picker, input_html: { value: Date.today }
        end
      else
        para "You can add new prices from the product detail page after creating the product."
      end
    end
    
    f.actions
  end

  controller do
    def create
      @product = Product.new(permitted_params[:product])
      
      if @product.save
        if params[:product][:product_prices_attributes].present?
          params[:product][:product_prices_attributes].each do |_, price_attrs|
            @product.product_prices.create(
              price: price_attrs[:price],
              effective_date: price_attrs[:effective_date]
            )
          end
        end
        redirect_to admin_product_path(@product), notice: "Product was successfully created."
      else
        render :new
      end
    end
  end
  
  member_action :add_price, method: :post do
    @product = Product.find(params[:id])
    @product.product_prices.create(
      price: params[:product_price][:price],
      effective_date: params[:product_price][:effective_date]
    )
    redirect_to admin_product_path(@product), notice: "Price was successfully added."
  end
end