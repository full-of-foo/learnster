class UserController < ApplicationController
    respond_to :json

    # def index
    #     render :json => User.all().to_json(:include => { :created_by => { :only => :id }, :admin_for => { :only => :id }})
    # end

    # def show
    #     render :json => User.find(params[:id]).to_json(:include => { :created_by => { :only => :id }, :admin_for => { :only => :id }})
    # end

    # def create
    #     render :json => User.create(permitted_user_params.user)
    # end

    # def update
    #     render :json => User.update(params[:id], permitted_user_params.user)
    # end

    # def destroy
    #     render :json => User.destroy(params[:id])
    # end

end
