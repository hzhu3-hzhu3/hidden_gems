ActiveAdmin.register Page do
  menu priority: 4, label: "Static Pages"
  
  permit_params :slug, :body
  
  actions :all, except: [:destroy]
  
  filter :slug
  filter :body
  filter :created_at
  filter :updated_at
  
  index do
    selectable_column
    id_column
    column :slug do |page|
      page.slug.titleize
    end
    column :preview do |page|
      truncate(strip_tags(page.body), length: 100)
    end
    column :updated_at
    column :actions do |page|
      links = []
      links << link_to("View on Site", page_path(page.slug), class: "member_link", target: "_blank")
      links << link_to("Edit", edit_admin_page_path(page), class: "member_link")
      links.join(' ').html_safe
    end
  end
  
  show do
    attributes_table do
      row :id
      row :slug do |page|
        page.slug.titleize
      end
      row :body do |page|
        div class: "page-content" do
          page.body.html_safe
        end
      end
      row :created_at
      row :updated_at
      row :view_on_site do |page|
        link_to "View on Site", page_path(page.slug), target: "_blank"
      end
    end
  end
  
  form do |f|
    f.semantic_errors
    
    f.inputs "Page Details" do
      if f.object.new_record?
        f.input :slug, as: :select, collection: ["about", "contact", "faq", "privacy", "terms"]
      else
        f.input :slug, input_html: { disabled: true }, hint: "The page slug cannot be changed after creation."
      end
      f.input :body, as: :quill_editor
    end
    
    f.actions
  end
  
  controller do
    def scoped_collection
      super.where(slug: ["about", "contact", "faq", "privacy", "terms"])
    end
    
    def index
      %w[about contact].each do |slug|
        unless Page.exists?(slug: slug)
          Page.create(
            slug: slug,
            body: "<h1>#{slug.titleize}</h1><p>This is the #{slug} page. Edit this content in the admin panel.</p>"
          )
        end
      end
      super
    end
  end
end