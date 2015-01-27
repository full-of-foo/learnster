require 'test_helper'

class AppAdminTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, AppAdmin.new.valid?
  end

  test 'is valid' do
    unsaved_app_admin = build(:app_admin)
    app_admin = create(:app_admin)

    assert_equal true, unsaved_app_admin.valid?
    assert_equal true, app_admin.valid?
  end

  test 'knows parent model name' do
    assert_equal "User", AppAdmin.model_name.name
  end

  test 'knows model type' do
    app_admin = build(:app_admin)

    assert_equal false, app_admin.student?
    assert_equal false, app_admin.org_admin?
    assert_equal true, app_admin.app_admin?
  end

end
