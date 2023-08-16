module Aws
  module Api
    AWS_ACCESS_KEY_ID = ENV['AWS_ACCESS_KEY_ID']
    AWS_SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY']
    AWS_REGION = ENV["AWS_REGION"]

    def self.client
      Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"])
    end
  end
end
