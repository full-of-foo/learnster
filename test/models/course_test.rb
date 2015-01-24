require 'test_helper'

class CourseTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, Course.new.valid?
  end

  test 'is valid' do
    unsaved_course = build(:course, title: "BSc in Unsaved Studies")
    course = create(:course)

    assert_equal true, unsaved_course.valid?
    assert_equal true, course.valid?
  end

  test 'seaches' do
    create(:course)
    accounting = create(:course, title: "MSc in Accounting")

    assert_equal 2, Course.search_term("").size
    assert_equal 1, Course.search_term("Accounting").size
    assert_equal accounting.title, Course.search_term("MSc in A").first.title
  end

  test 'searches via organisation' do
    accounting = create(:course, title: "MSc in Accounting")
    dit = accounting.organisation
    dcu = create(:organisation, :dcu)

    assert_equal 1, Course.search_term("", nested_org=dit).size
    assert_equal 0, Course.search_term("", nested_org=dcu).size
  end

  test 'searches via managed by ID' do
    accounting = create(:course, title: "MSc in Accounting")
    accounting_manager_id = accounting.managed_by.id
    dcu_admin_id = create(:organisation, :dcu).created_by.id

    assert_equal 1, Course.search_term("", nested_org = nil, managed_by_id=accounting_manager_id).size
    assert_equal 0, Course.search_term("",  nested_org = nil, managed_by_id=dcu_admin_id).size
  end

  test 'searches via student ID' do
    enrolled_student_id = create(:enrollment).student.id
    unenrolled_student_id = create(:student).id

    assert_equal 1, Course.search_term("", nested_org = nil, managed_by_id=nil, student_id=enrolled_student_id).size
    assert_equal 0, Course.search_term("",  nested_org = nil, managed_by_id=nil, student_id=unenrolled_student_id).size
  end

  test 'lists courses by student' do
    enrolled_student_id = create(:enrollment).student.id
    unenrolled_student_id = create(:student).id

    assert_equal 1, Course.student_courses(enrolled_student_id).size
    assert_equal 0, Course.student_courses(unenrolled_student_id).size
  end
end