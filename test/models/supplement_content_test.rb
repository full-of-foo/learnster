require 'test_helper'

class SupplementContentTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, SupplementContent.new.valid?
  end

  test 'is valid' do
    unsaved_supplement_content = build(:supplement_content)
    supplement_content = create(:supplement_content)

    assert_equal true, unsaved_supplement_content.valid?
    assert_equal true, supplement_content.valid?
  end

  test 'lists contents by organisation' do
    dit_id = create(:supplement_content).module_supplement.learning_module.organisation.id
    dcu_id = create(:organisation, :dcu).id

    assert_equal 1, SupplementContent.organisation_contents(dit_id).size
    assert_equal 0, SupplementContent.organisation_contents(dcu_id).size
  end

  test 'lists contents by educator' do
    dit_educator_id = create(:supplement_content).module_supplement.learning_module.educator.id
    dcu_educator_id = create(:org_admin, :dcu).id

    assert_equal 1, SupplementContent.organisation_contents(dit_educator_id).size
    assert_equal 0, SupplementContent.organisation_contents(dcu_educator_id).size
  end

  test 'lists contents by student' do
    dit_module = create(:supplement_content).module_supplement.learning_module
    dit_enrollment = create(:enrollment)
    dit_student_id = dit_enrollment.student.id
    dit_enrollment.course_section.learning_modules << dit_module
    dcu_student_id = create(:student, :dcu).id

    assert_equal 1, SupplementContent.student_contents(dit_student_id).size
    assert_equal 0, SupplementContent.student_contents(dcu_student_id).size
  end
end