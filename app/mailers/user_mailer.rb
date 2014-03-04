class UserMailer < ActionMailer::Base
  default from: ENV['GMAIL_USERNAME']

  def signup_confirmation(admin, confirmation_url)
    @admin = admin
    @confirmation_url = confirmation_url

    mail to: admin.email, subject: "Account Confirmation"
  end
end
