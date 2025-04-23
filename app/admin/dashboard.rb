ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Dashboard"

  content title: "Welcome to Hidden Gems Admin" do
    div class: "row" do
      div class: "col-md-6" do
        panel "Quick Links" do
          ul class: "list-group" do
            li class: "list-group-item" do
              link_to "Manage Products", admin_products_path
            end
            li class: "list-group-item" do
              link_to "Manage Categories", admin_categories_path
            end
            li class: "list-group-item" do
              link_to "Manage Orders", admin_orders_path
            end
          end
        end
      end

      div class: "col-md-6" do
        panel "System Info" do
          para "You're signed in as #{current_admin_user.email}"
          para "Current time: #{Time.current.strftime('%B %d, %Y %H:%M')}"
        end
      end
    end
  end
end
