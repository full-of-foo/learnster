require 'test_helper'
require 'erb'

class UserMailerTest < ActiveSupport::TestCase

  test 'can send signup confirmation' do
    admin = create(:org_admin, email: "admin@dit.ie", role: "account_manager")
    confirmation_url = "test.ie#/signup/#{admin.id}/confirm/#{admin.confirmation_code}"
    email = UserMailer.signup_confirmation(admin, confirmation_url).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['signup@learnstermailer.com'], email.from
    assert_equal ['admin@dit.ie'], email.to
    assert_equal 'Account Confirmation', email.subject

    assert_equal true, email.body.to_s.include?("#{admin.full_name},")
    assert_equal true, email.body.to_s.include?("Thank you for signing up.")
    assert_equal true, email.body.to_s.include?(confirmation_url)
    assert_equal true, email.body.to_s.include?("Kind Regards,")
    assert_equal true, email.body.to_s.include?("Learnster Team")
  end

end
