ActionMailer::Base.smtp_settings = {
  address:              ENV['MAIL_SMTP_SERVER'],
  port:                 ENV['MAIL_PORT'],
  domain:               ENV['DOMAIN'],
  user_name:            ENV['MAIL_USER_NAME'],
  password:             ENV['MAIL_PASSWORD'],
  authentication:       'plain'
}

ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_url_options[:host] = ENV['MAIL_HOST']
