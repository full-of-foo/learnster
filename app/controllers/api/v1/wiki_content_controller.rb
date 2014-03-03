class Api::V1::WikiContentController < ApplicationController
  after_filter only: [:index] { paginate(:supplement_contents) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]

  def create
    @supplement_content = WikiContent.new
    params = permitted_params.wiki_content_params.merge(create_params)

    if @supplement_content.update params
      track_activity @supplement_content
      render "api/v1/supplement_content/show"
    else
      respond_with @supplement_content
    end
  end

  def update
    @supplement_content = WikiContent.find(params[:id])
    params = permitted_params.wiki_content_params()

    if @supplement_content.update params
      track_activity @supplement_content
      render "api/v1/supplement_content/show"
    else
      respond_with @supplement_content
    end
  end

  def show
    @supplement_content = WikiContent.find(params[:id])
    if @supplement_content
      render "api/v1/supplement_content/show"
    else
      respond_with @supplement_content
    end
  end

  private
    def create_params
       params[:module_supplement] ? {module_supplement: ModuleSupplement.find(params[:module_supplement][:id])} : {}
    end

end
