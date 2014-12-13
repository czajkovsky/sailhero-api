class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  process :set_content_type

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{timestamp}-#{super}" unless original_filename.nil?
  end

  def timestamp
    var = :"@#{mounted_as}_timestamp"
    t = Time.now.to_i
    model.instance_variable_get(var) || model.instance_variable_set(var, t)
  end
end
