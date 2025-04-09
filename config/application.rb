

require_relative "boot"
require "rails/all"


Bundler.require(*Rails.groups)

module HiddenGems
  class Application < Rails::Application
    config.load_defaults 7.0
    config.autoload_paths << Rails.root.join("lib")

    Rails.autoloaders.main.ignore(
      Rails.root.join("lib/assets"),
      Rails.root.join("lib/tasks")
    )
    config.assets.paths << Rails.root.join("app", "assets", "builds")

  end
end
