class Api::V1::SignUpController < ApplicationController

  def show_valid_admin
    @org_admin = OrgAdmin.where(id: params[:id], confirmation_code: params[:code])

    if @org_admin
      render "api/v1/org_admin/show"
    else
      respond_with @org_admin
    end
  end

  def sign_up_account_manager
    @org_admin = OrgAdmin.new
    params = permitted_params.sign_up_params.merge create_params

    if @org_admin.update params
      @confirmation_url = root_url + "#/signup/#{@org_admin
        .id}/confirm/#{@org_admin.confirmation_code}"
      UserMailer.signup_confirmation(@org_admin, @confirmation_url).deliver

      render "api/v1/org_admin/show"
    else
      respond_with @org_admin
    end
  end

  def confirm_administrator_account
    @org_admin = OrgAdmin.find(params[:id])
    valid_confirm = @org_admin.confirmation_code == params[:code]
    has_registered = !@org_admin.admin_for.nil?
    has_confirmed = @org_admin.confirmed

    if !has_confirmed && valid_confirm && !has_registered
      @org_admin.update! confirmed: true
      render "api/v1/org_admin/show"
    else
      respond_with @org_admin
    end
  end


  private
    def create_params
      { is_active: false, role: 'account_manager', confirmed: false,
        last_login: Time.zone.now, password: params[:password],
        password_confirmation: params[:password_confirmation] }
    end

end
