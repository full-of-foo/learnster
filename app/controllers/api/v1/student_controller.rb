class Api::V1::StudentController < ApplicationController
  after_filter only: [:index] {
    paginate(:students) if not params[:created_months_ago] and not params[:updated_months_ago]
  }

  before_filter :authenticate_and_authorize
  before_filter :find_org

  def index
    if search_request?
      @students = Student.search_term(params[:search]).order("created_at desc")
        .page(params[:page]).per_page(20)      if search_term_request?(params)
      @students = Student.search_term(params[:search], nil, params[:created_by]).order("created_at desc")
        .page(params[:page]).per_page(20)                                                    if nested_org_term_search?(params) && params[:created_by]
      @students = Student.search_term(params[:search], nil, nil, params[:student_id]).order("created_at desc")
        .page(params[:page]).per_page(20)                                                    if nested_org_term_search?(params) && params[:student_id]
      @students = Student.search_term(params[:search], @org).order("created_at desc")
      .page(params[:page]).per_page(20)                                                      if nested_org_term_search?(params) && !params[:created_by] && !params[:student_id]
      @students = Student.search_range(params[:created_months_ago], :created_at)             if created_at_search?(params)
      @students = Student.search_range(params[:updated_months_ago], :updated_at)             if updated_at_search?(params)
      @students = Student.search_range(params[:created_months_ago], :created_at, @org)       if nested_org_created_at_search?(params)
      @students = Student.search_range(params[:updated_months_ago], :updated_at, @org)       if nested_org_updated_at_search?(params)
      return @students
    end

    if params[:page] && !params[:section_id] && !params[:created_by] && !params[:student_id]
      @students = nested_org_request?(params) ? @org.students().order("created_at desc")
        .page(params[:page]).per_page(20) : Student.all.order("created_at desc")
          .page(params[:page]).per_page(20)

    elsif params[:page] && params[:section_id]
      @students = CourseSection.find(params[:section_id]).students.order("created_at desc")
        .page(params[:page]).per_page(20)

    elsif !params[:page] && params[:section_id]
      @students = CourseSection.find(params[:section_id]).students.order("created_at desc")

    elsif params[:page] && params[:created_by]
      @students = OrgAdmin.find(params[:created_by]).created_students.order("created_at desc")
        .page(params[:page]).per_page(20)
    elsif params[:page] && params[:student_id]
      @students = Student.coursemates(params[:student_id]).order("created_at desc")
        .page(params[:page]).per_page(20)
    else
      @students = nested_org_request?(params) ? @org.students.order("created_at desc") : Student
        .all.order("created_at desc")
    end


    if xlsx_request?
      if !@students || @students.empty?
        @students = Student.none
      end

      respond_to do |format|
        format.xlsx {
          send_data @students.to_xlsx.to_stream.read, :filename => 'students.xlsx',
          :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
         }
      end
    end
    @students
  end

  def show
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])

    if @student.update permitted_params.user_params().merge update_params
      track_activity @student
      render "api/v1/student/show"
    else
      respond_with @student
    end
  end

  def create
    @student = Student.new
    params = permitted_params.user_params().merge create_params

    if @student.update params
      track_activity @student
      render "api/v1/student/show"
    else
      respond_with @student
    end
  end

  def destroy
    @student = Student.find(params[:id])

    if @student.destroy()
      untrack_trackable params[:id]
      render json: {}
    else
      respond_with @student
    end
  end

  def import
    if nested_org_request?(params) and ['.csv', '.xls', '.xlsx'].include? File.extname(params[:qqfilename])
      import_status_data = Student.import_with_validation(params[:qqfile], @org, current_user)
      if import_status_data.values.all? { |value| value == true } and not import_status_data.empty?
        render :json => { :success => true }
      else
        render :json => { :success => false, :error => import_status_data,
         :preventRetry => true }, :status => 422
      end
    else
      render :json => { :success => false, :error => { "File Type Error" => "Invalid file uploaded" },
       :preventRetry => true }, :status => :unauthorized
    end
  end


  private

    # virtual params on update
    def update_params
      { password: params[:password], password_confirmation: params[:password_confirmation] }
    end

    # virtual params on create
    def create_params
      org = Organisation.find_by(title: params[:attending_org]) if current_user.app_admin?
      org = current_user.admin_for if current_user.org_admin?

      { created_by: current_user, attending_org: org, is_active: false,
        last_login: Time.zone.now, password: params[:password],
        password_confirmation: params[:password_confirmation] }
    end
end
