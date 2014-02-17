class Api::V1::EnrolledCourseSectionController < ApplicationController
  after_filter only: [:index] { paginate(:enrolled_course_sections) }
  before_filter :authenticate_and_authorize

  def create
    @enrolled_course_section = EnrolledCourseSection.new
    params = permitted_params.enrolled_course_section_params().merge create_params

    if @enrolled_course_section.update params
      render "api/v1/enrolled_course_section/show"
    else
      respond_with @enrolled_course_section
    end
  end

  def update
    @enrolled_course_section = EnrolledCourseSection.find(params[:id])
    params = permitted_params.enrolled_course_section_params().merge create_params

    if @enrolled_course_section.update params
      render "api/v1/enrolled_course_section/show"
    else
      respond_with @enrolled_course_section
    end
  end

  def destroy
    @enrolled_course_section = EnrolledCourseSection
      .where(student_id: params[:student_id], course_section_id: params[:course_section_id])
        .first

    if @enrolled_course_section && @enrolled_course_section.destroy()
      render json: {}
    else
      @enrolled_course_section = EnrolledCourseSection.new
      @enrolled_course_section.errors.add(:student_id, "Not enrolled")
      respond_with @enrolled_course_section
    end
  end


  private
    def create_params
      student = Student.where(email: params[:student_id]).first
      {student: student}
    end

end
