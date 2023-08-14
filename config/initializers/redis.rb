require 'redis'
if ENV["REDIS_PASSWORD"].present?
  $redis = Redis.new(username: ENV["REDIS_USERNAME"], url: ENV["REDIS_URL"], password: ENV["REDIS_PASSWORD"])
else
  $redis = Redis.new(username: ENV["REDIS_USERNAME"], url: ENV["REDIS_URL"])
end
