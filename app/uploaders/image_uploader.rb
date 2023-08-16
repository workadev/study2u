class ImageUploader < BaseUploader
  plugin :validation_helpers

  Attacher.validate do
    super() # empty parentheses are required
    # validate_max_size 10.megabytes
    # validate_mime_type_inclusion %w[image/jpg image/jpeg image/png image/svg]
  end

  # Attacher.derivatives_processor do |original|
  #   {
  #     large:  magick.resize_to_limit!(800, 800),
  #     medium: magick.resize_to_limit!(500, 500),
  #     small:  magick.resize_to_limit!(300, 300)
  #   }
  # end
end
