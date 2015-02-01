require 'test_helper'
require 'csv'

class UserTest < ActiveSupport::TestCase

  # TODO - test search_range

  test 'not valid by default' do
    assert_equal false, User.new.valid?
  end

  test 'is valid' do
    unsaved_user = build(:user)
    user = create(:user)

    assert_equal true, unsaved_user.valid?
    assert_equal true, user.valid?
  end

  test 'adds API key before create' do
    unsaved_user = build(:user)
    user = create(:user)

    assert_equal 0, unsaved_user.api_keys.size
    assert_equal 1, user.api_keys.size
  end

  test 'sets default arguments before create' do
    user = create(:user)
    student = create(:student)
    account_manager = create(:org_admin, role: "account_manager")
    module_manager = create(:org_admin, role: "module_manager")
    course_manager = create(:org_admin, role: "course_manager")

    assert_equal nil, User.new.confirmation_code
    assert_equal true, user.confirmation_code.is_a?(String)
    assert_equal 32, user.confirmation_code.size

    assert_equal false, User.new.confirmed
    assert_equal false, Student.new.confirmed
    assert_equal true, student.confirmed
    assert_equal false, OrgAdmin.new.confirmed
    assert_equal false, account_manager.confirmed
    assert_equal true, module_manager.confirmed
    assert_equal true, course_manager.confirmed
  end

  test 'lists authenticated users' do
    user = create(:user)
    token = user.api_keys.first.access_token

    assert_equal user, User.authenticated_user(token)
    assert_equal false, User.authenticated_user("trolololol")
  end

  test 'can open spreadsheets' do
    CSV.open("#{Rails.root}/tmp/greeting.csv", "wb") { |csv| csv << ["Oh hey"] }
    File.new("#{Rails.root}/tmp/bad.txt", "w")
    csv_upload = Rack::Test::UploadedFile.new("#{Rails.root}/tmp/greeting.csv")
    bad_upload = Rack::Test::UploadedFile.new("#{Rails.root}/tmp/bad.txt")

    assert_equal "Oh hey", User.open_spreadsheet(csv_upload).cell(1, 1)
    assert_raises(RuntimeError) { User.open_spreadsheet(bad_upload) }
  end

  test 'knows full name' do
    user = create(:user, first_name: "Paul", surname: "Blart")

    assert_equal "Paul Blart", user.full_name
  end

  test 'can authenticate and confirm self' do
    pass = "ihazhackz"
    dit = create(:organisation)
    user = create(:user, password: pass, password_confirmation: pass)
    student = create(:student, password: pass, password_confirmation: pass)
    account_manager = create(:org_admin, role: "account_manager", admin_for: dit,
                              password: pass, password_confirmation: pass)
    module_manager = create(:org_admin, role: "module_manager", admin_for: dit,
                             password: pass, password_confirmation: pass)
    course_manager = create(:org_admin, role: "course_manager", admin_for: dit,
                             password: pass, password_confirmation: pass)

    assert_equal user.authenticate_and_confirm(pass), true
    assert_equal student.authenticate_and_confirm(pass), true
    assert_equal module_manager.authenticate_and_confirm(pass), true
    assert_equal course_manager.authenticate_and_confirm(pass), true

    assert_equal account_manager.authenticate_and_confirm(pass), false
    account_manager.confirmed = true
    assert_equal account_manager.authenticate_and_confirm(pass), true
  end

end
