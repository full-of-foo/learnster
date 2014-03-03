class Api::V1::SupplementContentController < ApplicationController
  after_filter only: [:index] { paginate(:supplement_contents) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]


  def index
    if params[:module_supplement_id]
      @supplement_contents = ModuleSupplement.find(params[:module_supplement_id])
        .supplement_contents

    elsif params[:educator_id]
      @supplement_contents = SupplementContent.educator_contents(params[:educator_id])

    elsif params[:student_id]
      @supplement_contents = SupplementContent.student_contents(params[:student_id])

    else
      @supplement_contents = nested_org_request?(params) ? SupplementContent
        .organisation_contents(@org.id) : SupplementContent.all

    end

    return @supplement_contents
  end

  def show
    @supplement_content = SupplementContent.find(params[:id])
  end


  def destroy
    @module_supplement = SupplementContent.find(params[:id])

    if @module_supplement.destroy()
      untrack_trackable params[:id]
      render json: {}
    else
      respond_with @module_supplement
    end
  end

end
