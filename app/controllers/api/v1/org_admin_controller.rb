module Api
	module V1

		class OrgAdminController < ApplicationController
		    respond_to :json
		    before_filter :find_org
		    before_filter :require_login
		    

		    def index
		    	if search_request?
			    	@search = OrgAdmin.search do
			    		fulltext params[:search]
			    		with(:org_id).equal_to(params[:organisation_id]) if nested_org_request?(params)
			    		paginate :page => 1, :per_page => 10000
			    	end
			        return (@org_admins = @search.results)
		    	end
		    	
		    	@org_admins = nested_org_request?(params) ? @org.admins() : OrgAdmin.all()

		    	if xlsx_request?
		    		respond_to do |format|
			  			format.xlsx {
			            	send_data @org_admins.to_xlsx.to_stream.read, :filename => 'admins.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
			       		 }
		  			end	
		        end

				@org_admins		
			 end

		    def show
		  		@org_admin = OrgAdmin.find(params[:id])
			end

			def update
				@org_admin = OrgAdmin.find(params[:id])
				if @org_admin.update permitted_params.org_admin_params().merge update_params
					render "api/v1/org_admin/show"
				else
					respond_with @org_admin
				end
			end

			def create
				@org_admin = OrgAdmin.new
				params = permitted_params.org_admin_params().merge create_params
				if @org_admin.update params
					render "api/v1/org_admin/show"
				else
					respond_with @org_admin
				end
			end

			def destroy
		  		org_admin = OrgAdmin.find(params[:id])
		  		org_admin.destroy()
		  		render json: {}
			end


			private

				#virtual params on update
				def update_params
					{ password: params[:password], password_confirmation: params[:password_confirmation] }
				end

				#virtual params on create
				def create_params
					org = Organisation.find_by(title: params[:admin_for])  	  if current_user.app_admin?
					org = current_user.admin_for 							  if current_user.org_admin?

					{ created_by: current_user, admin_for: org, is_active: false, 
						last_login: Time.zone.now, password: params[:password], 
						password_confirmation: params[:password_confirmation] }
				end
		end
	end
 end
 