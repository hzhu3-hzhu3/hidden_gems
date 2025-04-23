# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "bootstrap", to: "bootstrap.min.js"
pin "@popperjs/core", to: "popper.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"


pin "active_admin", to: "active_admin.js"