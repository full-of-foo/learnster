class Api::V1::SignUpController < ApplicationController

  def sign_up_account_manager
    @org_admin = OrgAdmin.new
    params = permitted_params.sign_up_admin_params.merge create_params
    # automated testing hack
    params[:confirmed] = true if params[:email] == "signup@foo.com"

    if @org_admin.update params
      @confirmation_url = root_url + "#/signup/#{@org_admin.id}/confirm/#{@org_admin.confirmation_code}"

      OrgAdmin.delay(queue: "confirm_email").deliver_confirmation_mail(@org_admin.id, @confirmation_url)
      render "api/v1/org_admin/show"
    else
      respond_with @org_admin
    end
  end

  def confirm_administrator_account
    @org_admin = OrgAdmin.where(id: params[:id],
     confirmation_code: params[:code]).first
    has_registered = @org_admin && !@org_admin.admin_for.nil?
    has_confirmed = @org_admin && @org_admin.confirmed

    if @org_admin && !has_registered
      @org_admin.update!(confirmed: true) if !has_confirmed
      render "api/v1/org_admin/show"
    else
      errors = []
      errors << "Admin no longer exists" if !@org_admin
      errors << "Already registered"     if has_registered
      render json: {
          errors: { email: "", password: errors }
        }, status: 401 # redirect
    end
  end

  def auth_administrator_account
    @org_admin = OrgAdmin.find_by_email(params[:email])
    has_auth = @org_admin && @org_admin.authenticate(params[:password])
    has_confirmed = @org_admin && @org_admin.confirmed
    has_registered = @org_admin && !@org_admin.admin_for.nil?

    if has_auth && has_confirmed
      render "api/v1/org_admin/show"
    else
      errors = []
      errors << "Invalid email or password" if !has_auth
      errors << "Already registered" if has_registered
      errors << "Account not confirmed" if !has_confirmed
      render json: {
          errors: { email: "", password: errors }
        }, status: 422
    end
  end

  def sign_up_organisation
    @org_admin = OrgAdmin
      .where(id: params[:id], confirmation_code: params[:code]).first

    has_registered = @org_admin && !@org_admin.admin_for.nil?
    @organisation = Organisation.new
    params = permitted_params.sign_up_org_params
    params[:created_by] = @org_admin

    if !has_registered && @organisation.update(params)
        @organisation.admins << @org_admin
        render "api/v1/organisation/show"
    else
      if has_registered
        @organisation.errors.add(:description, "You have already created \
          an organisation")
        @organisation.errors.add(:title, "")
      end
      respond_with @organisation, :location => root_url
    end
  end


  private
    def create_params
      { is_active: false, role: 'account_manager', confirmed: false,
        last_login: Time.zone.now, password: params[:password],
        password_confirmation: params[:password_confirmation] }
    end

end
