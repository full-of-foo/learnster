require 'test_helper'

class EnrolledCourseSectionTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, EnrolledCourseSection.new.valid?
  end

  test 'is valid' do
    unsaved_enrollment = build(:enrollment)
    enrollment = create(:enrollment)

    assert_equal true, unsaved_enrollment.valid?
    assert_equal true, enrollment.valid?
  end

  test 'sets defaults on save' do
    unsaved_enrollment = build(:enrollment)
    enrollment = create(:enrollment)

    assert_equal nil, unsaved_enrollment.is_active
    assert_equal true, enrollment.is_active
  end

end