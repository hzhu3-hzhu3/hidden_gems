module ActiveAdmin
  module Views
    class HeaderRenderer < ::ActiveAdmin::Component
      def build(namespace, menu)
        super(id: "header")
        
        @namespace = namespace
        @menu = menu
        @utility_menu = @namespace.fetch_menu(:utility_navigation)
        
        site_title @namespace
        global_navigation @menu, class: "header-item tabs"
        utility_navigation @utility_menu, id: "utility_nav", class: "header-item tabs"
        
        add_custom_styles
      end
      
      private
      
      def add_custom_styles
        @header.instance_eval do
          style("background-color: #d791a3 !important")
          style("color: #fff !important")
          style("padding: 1rem !important")
        end
      end
    end
  end
end