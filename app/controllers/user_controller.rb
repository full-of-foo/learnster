class UserController < ApplicationController
    respond_to :json

    def index
        respond_with User.all
    end

    def show
        respond_with User.find(params[:id])
    end

    def create
        respond_with User.create(permitted_user_params.user)
    end

    def update
        respond_with User.update(params[:id], permitted_user_params.user)
    end

    def destroy
        respond_with User.destroy(params[:id])
    end

end
