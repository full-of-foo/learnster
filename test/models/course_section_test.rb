require 'test_helper'

class CourseSectionTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, CourseSection.new.valid?
  end

  test 'is valid' do
    unsaved_course_section = build(:course_section)
    course_section = create(:course_section)

    assert_equal true, unsaved_course_section.valid?
    assert_equal true, course_section.valid?
  end

  test 'lists organisation course sections' do
      dit_id = create(:course_section).course.organisation.id
      dcu_id = create(:organisation, :dcu).id

      assert_equal 1, CourseSection.organisation_course_sections(dit_id).size
      assert_equal 0, CourseSection.organisation_course_sections(dcu_id).size
  end

  test 'lists organisation course sections via course' do
      course = create(:course_section).course
      other_course = create(:course)
      dit_id = course.organisation.id

      assert_equal 1, CourseSection.organisation_course_sections(dit_id, course_id=course.id).size
      assert_equal 0, CourseSection.organisation_course_sections(dit_id, other_course).size
  end

end