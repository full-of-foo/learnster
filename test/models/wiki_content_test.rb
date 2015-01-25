require 'test_helper'

class WikiContentTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, WikiContent.new.valid?
  end

  test 'is valid' do
    unsaved_wiki_content = build(:wiki_content)
    wiki_content = create(:wiki_content)

    assert_equal true, unsaved_wiki_content.valid?
    assert_equal true, wiki_content.valid?
  end

end
