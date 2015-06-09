require 'test_helper'

class Api::V1::CourseControllerTest < ActionController::TestCase

  test "should get index" do
    get :index, :page => 1
    assert_response 401

    token = create(:org_admin, role: "course_manager").api_keys.first.access_token
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token)
    get :index, :page => 2
    assert_response 200
  end

end
