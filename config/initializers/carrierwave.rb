CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.storage    = :aws
    config.aws_bucket = ENV['S3_BUCKET']
    config.aws_acl    = :public_read
    config.store_dir  = nil
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

    config.aws_credentials = {
      access_key_id:     ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    }
  elsif Rails.env.development?
    config.storage :file
  elsif Rails.env.test?
    config.storage :file
    AvatarUploader # auto load class
    CarrierWave::Uploader::Base.descendants.each do |klass|
      next if klass.anonymous?
      klass.class_eval do
        def cache_dir
          "#{Rails.root}/spec/uploads/tmp"
        end

        def store_dir
          model_specific_path = "#{model.class.to_s.underscore}/#{model.id}"
          "#{Rails.root}/spec/uploads/#{model_specific_path}"
        end
      end
    end
  end
end
