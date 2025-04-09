ActiveAdmin.register Product do
  permit_params :name, :description, :photo, category_ids: []
  actions :all

  filter :name
  filter :description
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :name
    column :description
    
    column :photo do |product|
      if product.photo.attached?
        image_tag url_for(product.photo.variant(:thumb)), size: "100x100"
      else
        status_tag("No Image", class: "warning")
      end
    end
    
    actions defaults: false do |product|
      item "View", admin_product_path(product)
      item "Edit", edit_admin_product_path(product)
      item "Delete", admin_product_path(product), 
          method: :delete, 
          data: { confirm: "Are you sure?", turbo: false }, 
          class: "delete-link"
    end
  end

  show do
    attributes_table do
      row :name
      row :description
      row :categories do |product|
        product.categories.map(&:name).join(", ")
      end
      row :photo do |product|
        if product.photo.attached?
          image_tag url_for(product.photo), width: 300
        else
          "No Image"
        end
      end
    end
  end

  form html: { multipart: true } do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :photo, as: :file, hint: f.object.photo.attached? ? image_tag(url_for(f.object.photo.variant(:thumb))) : content_tag(:span, "No image yet")
      f.input :categories, as: :check_boxes, collection: Category.all
    end
    f.actions
  end

end