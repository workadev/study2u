require 'shrine'
if Rails.env.development?
  require "shrine/storage/file_system"
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"),
  }
elsif Rails.env.test?
  require 'shrine/storage/memory'
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new,
  }
else
  require "shrine/storage/s3"
  s3_options = {
    bucket: ENV["S3_BUCKET"],
    access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region: ENV["AWS_REGION"]
  }
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", upload_options: { server_side_encryption: "AES256", acl: "public-read" }, **s3_options),
    store: Shrine::Storage::S3.new(prefix: "images", upload_options: { server_side_encryption: "AES256", acl: "public-read" }, **s3_options),
  }
end
Shrine.plugin :activerecord
Shrine.plugin :presign_endpoint
Shrine.plugin :backgrounding
Shrine.plugin :derivatives, create_on_promote: true
Shrine.plugin :remote_url, max_size: 20*1024*1024

Shrine::Attacher.promote_block do
  PromoteJob.perform_async(self.class.name, record.class.name, record.id, name.to_s, file_data)
end
Shrine::Attacher.destroy_block do
  DestroyJob.perform_async(self.class.name, data)
end
