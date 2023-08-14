require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Study2uBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = 'Asia/Jakarta'

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.test_framework nil
      g.assets false
      g.helper false
    end

    config.autoload_paths += %W(#{config.root}/lib/class)
    config.eager_load_paths << "#{Rails.root}/lib"
  end
end
