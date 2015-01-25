require 'test_helper'

class SubmissionUploadTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, SubmissionUpload.new.valid?
  end

  test 'is valid' do
    unsaved_submission_upload = build(:submission_upload)
    submission_upload = create(:submission_upload)

    assert_equal true, unsaved_submission_upload.valid?
    assert_equal true, submission_upload.valid?
  end

end
