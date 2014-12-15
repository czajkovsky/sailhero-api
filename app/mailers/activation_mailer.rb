class ActivationMailer < ActionMailer::Base
  default "Message-ID" => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@#{ENV['DOMAIN']}"
  default from: "no-replay@#{ENV['DOMAIN']}"

  def confirm_account(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: 'Welcome to Sailhero!')
  end
end
