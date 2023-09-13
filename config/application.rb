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

    # ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    #   html_tag.html_safe
    # end

    config.action_view.field_error_proc = proc do |html_tag, instance|
      input_tag = Nokogiri::HTML5::DocumentFragment.parse(html_tag).at_css('.form-control')
      if input_tag
        input_tag.add_class('is-invalid').to_s.html_safe
      else
        html_tag
      end
    end

  end
end
