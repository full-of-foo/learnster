class Api::V1::SupplementContentController < ApplicationController
  after_filter only: [:index] { paginate(:supplement_contents) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]


  def index
    if params[:module_supplement_id]
      @supplement_contents = ModuleSupplement.find(params[:module_supplement_id])
        .supplement_contents.order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:educator_id]
      @supplement_contents = SupplementContent.educator_contents(params[:educator_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:student_id]
      @supplement_contents = SupplementContent.student_contents(params[:student_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    else
      @supplement_contents = nested_org_request?(params) ? SupplementContent
        .organisation_contents(@org.id).page(params[:page])
          .order("created_at desc").per_page(20) : SupplementContent.all
            .page(params[:page]).per_page(20)

    end

    return @supplement_contents
  end

  def show
    @supplement_content = SupplementContent.find(params[:id])
  end

  def destroy
    @supplement_content = SupplementContent.find(params[:id])

    if @supplement_content.destroy()
      render json: {}
    else
      respond_with @supplement_content
    end
  end

end
