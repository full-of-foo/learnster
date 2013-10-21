class Api::V1::ActivitiesController < ApplicationController
	respond_to :json

	def index
		@activities = PublicActivity::Activity.order("created_at desc")
		render "api/v1/activity/index.json.rabl"
	end
  
end
