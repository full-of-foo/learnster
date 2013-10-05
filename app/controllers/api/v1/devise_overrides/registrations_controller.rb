module Api
	module V1

		class DeviseOverrides::RegistrationsController < Devise::RegistrationsController

			respond_to :json

			def new
				super
			end
			
			def create
				super
			end

			def destroy
				super
			end

		end

	end	
end