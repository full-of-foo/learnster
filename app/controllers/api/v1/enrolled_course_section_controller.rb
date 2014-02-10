class Api::V1::EnrolledCourseSectionController < ApplicationController
  after_filter only: [:index] { paginate(:enrolled_course_sections) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]

  def create
    @course_section = CourseSection.new
    params = permitted_params.course_section_params.merge(create_params())

    if @course_section.update params
      track_activity @course_section
      render "api/v1/course_section/show"
    else
      respond_with @course_section
    end
  end

end
