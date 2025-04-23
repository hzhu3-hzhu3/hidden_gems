ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }
  
  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Welcome to Hidden Gems Admin" do
          div class: "dashboard-welcome" do
            h2 "Store Management Dashboard"
            para "Welcome to the admin panel for Hidden Gems e-commerce platform. Use the navigation menu to manage your products, orders, and more."
            
            div class: "stats-container" do
              div class: "stat-box" do
                h3 "#{Product.count}"
                para "Products"
              end
              
              div class: "stat-box" do
                h3 "#{Order.count}"
                para "Orders"
              end
              
              div class: "stat-box" do
                h3 "#{Customer.count}"
                para "Customers"
              end
              
              div class: "stat-box" do
                h3 "#{Category.count}"
                para "Categories"
              end
            end
          end
        end
      end
    end
    
    columns do
      column do
        panel "Recent Orders" do
          table_for Order.order(created_at: :desc).limit(5) do
            column :id do |order|
              link_to order.id, admin_order_path(order)
            end
            column :customer
            column :total_price do |order|
              number_to_currency(order.total_price)
            end
            column :status do |order|
              status_tag order.status,
              class: order.status == 'paid' ? :ok :
                   (order.status == 'pending' ? :warning :
                   (order.status == 'shipped' ? :yes : :error))
            end
            column :created_at
          end
          div class: "text-center" do
            link_to "View All Orders", admin_orders_path, class: "button"
          end
        end
      end
      
      column do
        panel "Product Filters" do
          div class: "dashboard-filters" do
            ul do
              li link_to("All Products", admin_products_path)
              li link_to("New Products", admin_products_path(q: { created_at_gteq: 3.days.ago }))
              li link_to("Recently Updated", admin_products_path(q: { updated_at_gt: 'created_at', updated_at_gteq: 3.days.ago }))
              li link_to("Manage Categories", admin_categories_path)
            end
          end
        end
        
        panel "Recently Updated Products" do
          ul class: "product-list" do
            Product.where("updated_at > created_at AND updated_at >= ?", 3.days.ago).limit(8).map do |product|
              li class: "product-item" do
                span do
                  status_tag "updated", class: "ok"
                end
                span style: "margin-left: 0.5rem;" do
                  link_to(product.name, admin_product_path(product))
                end
              end
            end
          end
        end
      end
    end
  end
end