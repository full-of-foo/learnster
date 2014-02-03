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
    params = permitted_params.sign_up_admin_params.merge create_params

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
    has_registered = !@org_admin.admin_for.nil?

    if !has_registered
      @org_admin.update! confirmed: true
      render "api/v1/org_admin/show"
    else
      respond_with @org_admin, :location => root_url
    end
  end

  def auth_administrator_account
    @admin = OrgAdmin.find_by_email(params[:email])
    errors = ["Invalid email or password"]
    errors << "Account not confirmed" if !@admin.confirmed

    if @admin && @admin.authenticate(params[:password]) && @admin.confirmed
      render "application/show_current_user.json.rabl"
    else
      render json: {
          errors: { email: "", password: errors }
        }, status: 422
    end
  end

  def sign_up_organisation
    @org_admin = OrgAdmin.where(id: params[:id], confirmation_code: params[:code])
    has_registered = !@org_admin.admin_for.nil?

    @organisation = Organisation.new
    params = permitted_params.sign_up_org_params

    if !has_registered && @organisation.update(params)
        @organisation.admins << @org_admin
        render "api/v1/organisation/show"
    else
      @organisation.errors.add(:title, { message: "You have already created \
        an organisation" }) if !has_registered
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
