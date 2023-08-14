require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'sidekiq-scheduler/web'

redis_password = ENV["REDIS_PASSWORD"].present? ? ENV["REDIS_PASSWORD"] : "123456789"

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["sidekiqadmin", redis_password]
end

sidekiq_config = { url: ENV["REDIS_URL"] }
sidekiq_config[:password] = ENV["REDIS_PASSWORD"] if ENV["REDIS_PASSWORD"].present?

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
