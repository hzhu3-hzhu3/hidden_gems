if defined?(Dartsass)
  Rails.application.config.dartsass.build_options = {
    sourceMap: true,
    style: :compressed,
    load_path: [
      Rails.root.join("app/assets/stylesheets").to_s
    ]
  }
  
  Rails.application.config.dartsass.builds = {
    "active_admin.scss"       => "active_admin.css",
    "active_admin_custom.scss" => "active_admin_custom.css"
  }
end