require 'test_helper'

class WikiSubmissionTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, WikiSubmission.new.valid?
  end

  test 'is valid' do
    unsaved_wiki_submission = build(:wiki_submission)
    wiki_submission = create(:wiki_submission)

    assert_equal true, unsaved_wiki_submission.valid?
    assert_equal true, wiki_submission.valid?
  end

  test 'counts wiki markup words' do
    wiki_submission = build(:wiki_submission, wiki_markup: "<div><b>I heart ruby</b></div>")

    assert_equal 3, wiki_submission.wiki_word_count
    wiki_submission.wiki_markup = "<html> </html>"
    assert_equal 0, wiki_submission.wiki_word_count
  end

end
