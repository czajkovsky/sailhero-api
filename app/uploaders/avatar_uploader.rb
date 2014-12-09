class AvatarUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{timestamp}-#{super}"
  end

  def timestamp
    "#{Time.now.to_i}-#{(0...20).map { (97 + rand(26)).chr }.join}"
  end
end
