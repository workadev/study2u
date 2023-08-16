module Aws
  module Api
    class S3
      S3_BUCKET = ENV["S3_BUCKET"]
      STORAGE_TYPE = [:cache, :store]

      def initialize
        @s3 = Aws::S3::Resource.new(region: Aws::Api::AWS_REGION, credentials: Aws::Api.client)
      end

      def fetch_object(storage_type:, filename:, bucket: nil)
        storage_type = STORAGE_TYPE.include?(storage_type) ? storage_type : :cache
        bucket = S3_BUCKET if bucket.blank?
        key = Shrine.storages[storage_type].prefix.to_s
        image = @s3.bucket(bucket).object("#{key}/#{filename}")
        return image, storage_type if image.exists?
      end
    end
  end
end
