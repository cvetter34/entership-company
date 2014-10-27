require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EntershipCompanies
  class Application < Rails::Application
    config.assets.paths << Rails.root.join("app", "vendor", "assets", "images")
    config.autoload_paths += %W(#{config.root}/lib)
    config.i18n.enforce_available_locales = false
  end
end
