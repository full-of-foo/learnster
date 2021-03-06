class Api::V1::CourseController < ApplicationController
  after_filter only: [:index] { paginate(:courses) }
  before_filter :authenticate_and_authorize
  before_filter :find_org


  def index
     if search_request?
      @courses = Course.search_term(params[:search]).order("created_at desc")
        .page(params[:page]).per_page(20)                                            if search_term_request?(params)
      @courses = Course.search_term(params[:search], nil, nil, params[:student_id])
        .order("created_at desc").page(params[:page]).per_page(20)                   if nested_org_term_search?(params) && !params[:managed_by] && params[:student_id]
      @courses = Course.search_term(params[:search], nil, params[:managed_by])
        .order("created_at desc").page(params[:page]).per_page(20)                   if nested_org_term_search?(params) && params[:managed_by] && !params[:student_id]
      @courses = Course.search_term(params[:search], @org).order("created_at desc")
        .page(params[:page]).per_page(20)                                            if nested_org_term_search?(params) && !params[:managed_by] && !params[:student_id]
      return @courses
    end

    if !params[:managed_by] && ! params[:student_id]
      @courses = nested_org_request?(params) ? @org.courses()
        .order("created_at desc").page(params[:page]).per_page(20) : Course.all
          .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:page] && params[:managed_by]
      @courses = OrgAdmin.find(params[:managed_by]).managed_courses
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:page] && params[:student_id]
      @courses = Course.student_courses(params[:student_id])
       .order("created_at desc").page(params[:page]).per_page(20)
    end

    if xlsx_request?
      respond_to do |format|
        format.xlsx {
          send_data @courses.to_xlsx.to_stream.read, :filename => 'courses.xlsx',
          :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
         }
      end
    end
    return @courses
  end

  def show
    @course = Course.includes(:organisation, :managed_by).find(params[:id])
  end

  def update
    @course = Course.find(params[:id])

    if @course.update permitted_params.course_params().merge create_and_update_params
      track_activity @course
      render "api/v1/course/show"
    else
      respond_with @course
    end
  end

  def create
    @course = Course.new
    params = permitted_params.course_params().merge create_and_update_params

    if @course.update params
      track_activity @course
      render "api/v1/course/show"
    else
      respond_with @course
    end
  end

  def destroy
    @course = Course.find(params[:id])

    if @course.destroy()
      render json: {}
    else
      respond_with @course
    end
  end

  private
    # virtual params on create
    def create_and_update_params
      @org = current_user.admin_for
      new_params =  { organisation_id: @org.id }
      if params[:managed_by].is_a?(String)
        new_params[:managed_by] =  OrgAdmin.where(email: params[:managed_by]).first
      end
      
      new_params
    end

end
