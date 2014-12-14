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
  elsif Rails.env.development? || Rails.env.test?
    config.storage :file
  end
end
