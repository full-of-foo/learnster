require 'test_helper'

class DeliverableTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, Deliverable.new.valid?
  end

  test 'is valid' do
    unsaved_deliverable = build(:deliverable)
    deliverable = create(:deliverable)

    assert_equal true, unsaved_deliverable.valid?
    assert_equal true, deliverable.valid?
  end

  test 'list deliverables by organisation' do
    dit_id = create(:deliverable).module_supplement.learning_module.organisation.id
    dcu_id = create(:organisation, :dcu).id

    assert_equal 1, Deliverable.organisation_deliverables(dit_id).size
    assert_equal 0, Deliverable.organisation_deliverables(dcu_id).size
  end

  test 'list deliverables by educator' do
    dit_educator_id = create(:deliverable).module_supplement.learning_module.educator.id
    dcu_educator_id = create(:org_admin, :dcu).id

    assert_equal 1, Deliverable.educator_deliverables(dit_educator_id).size
    assert_equal 0, Deliverable.educator_deliverables(dcu_educator_id).size
  end

  test 'list deliverables by student' do
    dit_enrollment = create(:enrollment)
    dit_student_id = dit_enrollment.student.id
    dit_module = create(:section_module, course_section: dit_enrollment.course_section).learning_module
    create(:deliverable, module_supplement: create(:module_supplement, learning_module: dit_module))
    dcu_student_id = create(:student, :dcu).id

    assert_equal 1, Deliverable.student_deliverables(dit_student_id).size
    assert_equal 0, Deliverable.student_deliverables(dcu_student_id).size
  end

  test 'list supplement deliverables by student' do
    dit_enrollment = create(:enrollment)
    dit_student_id = dit_enrollment.student.id
    dit_module = create(:section_module, course_section: dit_enrollment.course_section).learning_module
    dit_supplement = create(:module_supplement, learning_module: dit_module)
    create(:deliverable, module_supplement: dit_supplement)
    dcu_student_id = create(:student, :dcu).id

    assert_equal 1, Deliverable.student_deliverables(dit_student_id, dit_supplement.id).size
    assert_equal 0, Deliverable.student_deliverables(dcu_student_id, dit_supplement.id).size
  end

  test 'counts unique student submissions' do
    dit_deliverable = create(:deliverable)
    dcu_deliverable = create(:deliverable, :dcu)
    create(:submission, deliverable: dit_deliverable)

    assert_equal 1, dit_deliverable.unique_student_submission_count
    assert_equal 0, dcu_deliverable.unique_student_submission_count
  end

end