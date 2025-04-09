# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.paths << Gem.loaded_specs["activeadmin"].full_gem_path + "/app/assets/stylesheets"
Rails.application.config.assets.precompile += %w[active_admin_custom.css]
Rails.application.config.assets.precompile += %w( active_admin.css active_admin.js )


Rails.application.config.assets.paths << Rails.root.join("app", "assets", "builds")


# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
