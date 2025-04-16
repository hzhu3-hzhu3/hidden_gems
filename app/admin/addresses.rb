ActiveAdmin.register Address do
  menu false 
  
  permit_params :customer_id, :street, :city, :province_id, :postal_code
  
  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Customers', admin_customers_path)]
    if params[:action] != 'index'
      address = Address.find_by(id: params[:id])
      if address && address.customer
        links << link_to(address.customer.full_name, admin_customer_path(address.customer))
      end
    end
    links
  end
  
  index do
    selectable_column
    id_column
    column :customer
    column :street
    column :city
    column :province
    column :postal_code
    actions
  end
  
  show do
    attributes_table do
      row :id
      row :customer
      row :street
      row :city
      row :province
      row :postal_code
      row :created_at
      row :updated_at
    end
  end
  
  form do |f|
    f.semantic_errors
    
    f.inputs "Address Details" do
      f.input :customer
      f.input :street
      f.input :city
      f.input :province
      f.input :postal_code
    end
    
    f.actions
  end
end