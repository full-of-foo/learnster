require 'test_helper'

class LearningModuleTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, LearningModule.new.valid?
  end

  test 'is valid' do
    unsaved_learning_module = build(:module)
    learning_module = create(:module)

    assert_equal true, unsaved_learning_module.valid?
    assert_equal true, learning_module.valid?
  end

  test 'lists organisation modules' do
    dit_id = create(:module).organisation.id
    dcu_id = create(:organisation, :dcu).id

    assert_equal 1, LearningModule.organisation_modules(dit_id).size
    assert_equal 0, LearningModule.organisation_modules(dcu_id).size
  end

  test 'lists course modules' do
    dit_course_id = create(:section_module).course_section.course.id
    dcu_course_id = create(:course, :dcu).id

    assert_equal 1, LearningModule.course_modules(dit_course_id).size
    assert_equal 0, LearningModule.course_modules(dcu_course_id).size
  end

  test 'lists student modules' do
      dit_enrollment= create(:enrollment)
      dit_enrollment.course_section.learning_modules << create(:module)
      dit_student_id = dit_enrollment.student.id
      dcu_student_id = create(:student, :dcu).id

      assert_equal 1, LearningModule.student_modules(dit_student_id).size
      assert_equal 0, LearningModule.student_modules(dcu_student_id).size
  end

  test 'can find by org and title' do
    title = "Advanced Design Patterns"
    dit_id = create(:module, title: title).organisation.id
    dcu_id = create(:organisation, :dcu).id

    assert_equal title, LearningModule.find_by_org_and_title(dit_id, title).title
    assert_equal nil, LearningModule.find_by_org_and_title(dit_id, "Advanced Trolling Methods")
    assert_equal nil, LearningModule.find_by_org_and_title(dcu_id, title)
  end

  test 'searches' do
    create(:module, title: "Advanced Design Patterns")

    assert_equal 1, LearningModule.search_term("Advanced ").size
    assert_equal 1, LearningModule.search_term("").size
    assert_equal 0, LearningModule.search_term("Trolololol ").size
  end

  test 'searches via organisation' do
    dit = create(:module, title: "Advanced Design Patterns").organisation
    dcu = create(:organisation, :dcu)

    assert_equal 1, LearningModule.search_term("Advanced ", dit).size
    assert_equal 1, LearningModule.search_term("", dit).size
    assert_equal 0, LearningModule.search_term("Advanced ", dcu).size
    assert_equal 0, LearningModule.search_term("", dcu).size
  end

  test 'searches via educator' do
    dit_educator_id = create(:module, title: "Advanced Design Patterns").educator.id
    dcu_educator_id = create(:org_admin, :dcu).id

    assert_equal 1, LearningModule.search_term("Advanced ", nil, dit_educator_id).size
    assert_equal 1, LearningModule.search_term("", nil, dit_educator_id).size
    assert_equal 0, LearningModule.search_term("Advanced ", nil, dcu_educator_id).size
    assert_equal 0, LearningModule.search_term("", nil, dcu_educator_id).size
  end

  test 'searches via student' do
      dit_enrollment= create(:enrollment)
      dit_enrollment.course_section.learning_modules << create(:module, title: "Advanced Design Patterns")
      dit_student_id = dit_enrollment.student.id
      dcu_student_id = create(:student, :dcu).id

    assert_equal 1, LearningModule.search_term("Advanced ", nil, nil, dit_student_id).size
    assert_equal 1, LearningModule.search_term("", nil, nil, dit_student_id).size
    assert_equal 0, LearningModule.search_term("Advanced ", nil, nil, dcu_student_id).size
    assert_equal 0, LearningModule.search_term("", nil, nil, dcu_student_id).size
  end

  test 'counts the amount of shared course sections' do
      dp_module = create(:module, title: "Advanced Design Patterns")

      assert_equal 0, dp_module.shared_on_course_section_count
      create(:enrollment).course_section.learning_modules << dp_module
      assert_equal 1, dp_module.shared_on_course_section_count
      create(:enrollment).course_section.learning_modules << dp_module
      assert_equal 2, dp_module.shared_on_course_section_count
  end

    test 'counts the amount of students' do
      dp_module = create(:module, title: "Advanced Design Patterns")
      section = create(:section_module, learning_module: dp_module).course_section

      assert_equal 0, dp_module.student_count
      create(:enrollment, course_section: section)
      assert_equal 1, dp_module.student_count
  end
end
