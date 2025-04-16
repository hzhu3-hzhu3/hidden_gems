ActiveAdmin.register Category do
  menu priority: 5
  
  permit_params :name
  
  actions :all
  
  index do
    selectable_column
    id_column
    column :name
    column :products_count do |category|
      category.products.count
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
    
    panel "Products in this Category" do
      table_for category.products do
        column :id do |product|
          link_to product.id, admin_product_path(product)
        end
        column :name
        column :photo do |product|
          if product.photo.attached?
            image_tag url_for(product.photo.variant(:thumb)), style: "max-width: 50px; max-height: 50px;"
          else
            status_tag("No Image", class: "warning")
          end
        end
        column :current_price do |product|
          number_to_currency(product.current_price)
        end
      end
    end
  end
  
  form do |f|
    f.semantic_errors
    
    f.inputs "Category Details" do
      f.input :name
    end
    
    f.actions
  end

  controller do
    def destroy
      @category = Category.find(params[:id])
      if @category.destroy
        redirect_to admin_categories_path, notice: "Category was successfully destroyed."
      else
        redirect_to admin_categories_path, alert: "Failed to destroy category."
      end
    end
  end
end