class UserMailer < ActionMailer::Base
  default from: "learnster.automated.mailer@gmail.com"

  def signup_confirmation(admin)
    @admin = admin

    mail to: admin.email, subject: "Account Confirmation"
  end
end
