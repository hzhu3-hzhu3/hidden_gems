ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Welcome to Hidden Gems Admin" do
          div class: "dashboard-welcome" do
            h2 "Store Management Dashboard"
            para "Welcome to the admin panel for Hidden Gems e-commerce platform. Use the navigation menu to manage your products, orders, and more."
            
            div class: "stats-container", style: "display: flex; gap: 1rem; margin-top: 1rem;" do
              div class: "stat-box", style: "flex: 1; padding: 1rem; background-color: #e9f2ff; border-radius: 0.375rem;" do
                h3 "#{Product.count}", style: "font-size: 2rem; margin: 0; color: #0d6efd;"
                para "Products", style: "margin: 0;"
              end
              
              div class: "stat-box", style: "flex: 1; padding: 1rem; background-color: #fff4e6; border-radius: 0.375rem;" do
                h3 "#{Order.count}", style: "font-size: 2rem; margin: 0; color: #fd7e14;"
                para "Orders", style: "margin: 0;"
              end
              
              div class: "stat-box", style: "flex: 1; padding: 1rem; background-color: #e6f9f4; border-radius: 0.375rem;" do
                h3 "#{Customer.count}", style: "font-size: 2rem; margin: 0; color: #20c997;"
                para "Customers", style: "margin: 0;"
              end
              
              div class: "stat-box", style: "flex: 1; padding: 1rem; background-color: #f5f0ff; border-radius: 0.375rem;" do
                h3 "#{Category.count}", style: "font-size: 2rem; margin: 0; color: #6f42c1;"
                para "Categories", style: "margin: 0;"
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
              li class: "product-item", style: "margin-bottom: 0.5rem;" do
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