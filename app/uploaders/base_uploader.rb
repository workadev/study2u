class BaseUploader < Shrine
  plugin :determine_mime_type
  plugin :upload_endpoint if Rails.env.development? || Rails.env.test?

  def self.generate_json_data(object:, fields: [])
    fields.each do |field|
      file_id = object.try(:send, field)
      if file_id.present?
        filename = file_id.split('/').last
        file = upload_locally(object: object, filename: filename, file_id: file_id) if Rails.env.development?
        file = upload_to_s3(object: object, filename: filename) if Rails.env.staging? || Rails.env.production?
        if file.present?
          field_name = field.gsub("_id","")
          object.send(:"#{field_name}=", file)
        end
      end
    end
  end

  def self.upload_locally(object:, filename:, file_id:)
    if Rails.env.development?
      file = File.open(file_id) if File.exists?(file_id)
      if file.blank?
        object.errors.add(:base, "File with filename #{filename} not found")
        return
      end
      return file
    end
  end

  def self.upload_to_s3(object:, filename:, storage_type: nil, bucket: nil)
    if Rails.env.staging? || Rails.env.production?
      bucket = ENV["S3_BUCKET"] if bucket.blank?
      s3 = Aws::Api::S3.new
      image = s3.fetch_object(storage_type: :cache, filename: filename, bucket: bucket)
      if image.blank?
        object.errors.add(:base, "File with filename #{filename} in aws not found")
        return
      else
        {
          id: filename,
          storage: image[1],
          metadata: {
            filename: filename,
            size: image[0].size,
            mime_type: Rack::Mime.mime_type(File.extname(filename))
          }
        }.to_json
      end
    end
  end
end
