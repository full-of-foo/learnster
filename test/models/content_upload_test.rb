require 'test_helper'

class ContentUploadTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, ContentUpload.new.valid?
  end

  test 'is valid' do
    unsaved_content_upload = build(:content_upload)
    content_upload = create(:content_upload)

    assert_equal true, unsaved_content_upload.valid?
    assert_equal true, content_upload.valid?
  end

end
