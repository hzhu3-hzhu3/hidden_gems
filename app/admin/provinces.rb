ActiveAdmin.register Province do
  menu priority: 6, label: "Provinces & Taxes"
  
  permit_params :name, :gst_rate, :pst_rate, :has_hst
  
  index do
    selectable_column
    id_column
    column :name
    column :gst_rate do |province|
      "#{(province.gst_rate * 100).round(2)}%"
    end
    column :pst_rate do |province|
      "#{(province.pst_rate * 100).round(2)}%"
    end
    column :has_hst
    column :display_name
    actions
  end
  

  show do
    attributes_table do
      row :id
      row :name
      row :gst_rate do |province|
        "#{(province.gst_rate * 100).round(2)}%"
      end
      row :pst_rate do |province|
        "#{(province.pst_rate * 100).round(2)}%"
      end
      row :has_hst
      row :created_at
      row :updated_at
    end
    
    panel "Addresses in this Province" do
      table_for province.addresses do
        column :id
        column :customer
        column :street
        column :city
        column :postal_code
      end
    end
  end

  form do |f|
    f.semantic_errors
    
    f.inputs "Province Details" do
      f.input :name
      f.input :gst_rate, hint: "Enter as decimal (e.g. 0.05 for 5%)"
      f.input :pst_rate, hint: "Enter as decimal (e.g. 0.07 for 7%)"
      f.input :has_hst, label: "Uses Harmonized Sales Tax (HST)?"
    end
    
    f.actions
  end
end