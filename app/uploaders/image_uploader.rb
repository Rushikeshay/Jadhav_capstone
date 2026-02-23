class ImageUploader < CarrierWave::Uploader::Base
  # This line connects CarrierWave to Cloudinary
  include Cloudinary::CarrierWave

  # Comment out or remove this line:
  # storage :file 
end
