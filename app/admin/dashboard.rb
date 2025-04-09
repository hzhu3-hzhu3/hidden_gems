ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    div class: "dashboard-welcome" do
      h2 "Welcome to the Hidden Gems Admin Dashboard"
      para "Use the links below to filter and manage products."
    end
    
    div class: "dashboard-filters" do
      ul do
        li link_to("All Products", admin_products_path)
        li link_to("New Products", admin_products_path(filter: "new"))
        li link_to("Recently Updated", admin_products_path(filter: "recently_updated"))
      end
    end
    
    panel "Recently Updated Products" do
      ul do
        Product.where("updated_at > created_at AND updated_at >= ?", 3.days.ago).map do |product|
          li link_to(product.name, admin_product_path(product))
        end
      end
    end    
  end
end
