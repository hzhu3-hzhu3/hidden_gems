ActiveAdmin.register Province do
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
    column :created_at
    actions
  end
  
  filter :name
  filter :has_hst
  filter :created_at
  
  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :gst_rate
      f.input :pst_rate
      f.input :has_hst
    end
    f.actions
  end
end