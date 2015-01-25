require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, Submission.new.valid?
  end

  test 'is valid' do
    unsaved_submission = build(:submission)
    submission = create(:submission)

    assert_equal true, unsaved_submission.valid?
    assert_equal true, submission.valid?
  end

  test 'lists supplement submissions' do
    dit_supplement_id = create(:submission).deliverable.module_supplement.id
    dcu_supplement_id = create(:module_supplement).id

    assert_equal 1, Submission.supplement_submissions(dit_supplement_id).size
    assert_equal 0, Submission.supplement_submissions(dcu_supplement_id).size
  end

  test 'lists module submissions' do
    dit_module_id = create(:submission).deliverable.module_supplement.learning_module.id
    dcu_module_id = create(:module).id

    assert_equal 1, Submission.module_submissions(dit_module_id).size
    assert_equal 0, Submission.supplement_submissions(dcu_module_id).size
  end

end
