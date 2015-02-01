class UserMailer < ActionMailer::Base
  default from: ENV.fetch('GMAIL_USERNAME') { "signup@learnstermailer.com" }

  def signup_confirmation(admin, confirmation_url)
    @admin = admin
    @confirmation_url = confirmation_url

    mail to: admin.email, subject: "Account Confirmation"
  end
end
