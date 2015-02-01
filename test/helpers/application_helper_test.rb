require 'test_helper'

class ApplicationHelperTest < ActiveSupport::TestCase

  before do
    @object = Object.new
    @object.extend(ApplicationHelper)
  end

  test 'can raise not found' do
    assert_equal true, ApplicationHelper.method_defined?(:not_found)
    assert_raises(ActionController::RoutingError, 'Not Found') do
      @object.not_found
    end
  end

end
