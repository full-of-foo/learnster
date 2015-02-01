require 'test_helper'

class StudentTest < ActiveSupport::TestCase

  # TODO - test import
  # TODO - test search

  test 'not valid by default' do
    assert_equal false, Student.new.valid?
  end

  test 'is valid' do
    unsaved_student = build(:student)
    student = create(:student)

    assert_equal true, unsaved_student.valid?
    assert_equal true, student.valid?
  end

  test 'lists coursemates' do
    dit_student = create(:student)
    other_dit_student = create(:student)
    dcu_student = create(:student, :dcu)
    section = create(:course_section)
    create(:enrollment, student: dit_student, course_section: section)
    create(:enrollment, student: other_dit_student, course_section: section)

    assert_equal 2, Student.coursemates(dit_student.id).size
    assert_equal 0, Student.coursemates(dcu_student.id).size
  end

  test 'list module students' do
    dit_module = create(:module)
    dit_section = create(:course_section)
    create(:section_module, course_section: dit_section, learning_module: dit_module)
    create(:enrollment, course_section: dit_section)
    dcu_module = create(:module)

    assert_equal 1, Student.module_students(dit_module.id).size
    assert_equal 0, Student.module_students(dcu_module.id).size
  end

  test 'knows organisation ID' do
    dit = create(:organisation)
    dit_student = create(:student, attending_org: dit)

    assert_equal dit.id, dit_student.org_id
  end

  test 'knows organisation title' do
    dit = create(:organisation)
    dit_student = create(:student, attending_org: dit)

    assert_equal dit.title, dit_student.org_title
  end

  test 'knows model type' do
    student = build(:student)

    assert_equal true, student.student?
    assert_equal false, student.org_admin?
    assert_equal false, student.app_admin?
  end

end
