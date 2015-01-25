require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase

  test 'is valid by default' do
    assert_equal true, ApiKey.new.valid?
  end

  test 'is valid with student' do
    unsaved_api_key = build(:api_key, user: build(:student))
    api_key = create(:api_key, user: create(:student))

    assert_equal true, unsaved_api_key.valid?
    assert_equal true, api_key.valid?
  end

  test 'is valid with admin' do
    unsaved_api_key = build(:api_key, user: build(:org_admin))
    api_key = create(:api_key, user: create(:org_admin))

    assert_equal true, unsaved_api_key.valid?
    assert_equal true, api_key.valid?
  end

  test 'generates token on create' do
    created_api_key = create(:api_key, user: create(:org_admin))

    assert_equal nil, ApiKey.new.access_token
    assert_equal true, created_api_key.access_token.is_a?(String)
    assert_equal 32, created_api_key.access_token.size
  end

end
