require 'api_constraints'

Learnster::Application.routes.draw do

  # App routes
  scope "app" do
    get "", :to => "application#index", :as => :app_route
  end

  # Auxiallry routes
  get "current_user" => "application#show_current_user", :as => "current_user"
  root "application#index"


  # API routes
  namespace "api", defaults: {format: 'json'} do

    # Default API version
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      # Session routes
      delete "logout" => "sessions#destroy", :as => "logout"
      post "login" => "sessions#create", :as => "login"

      # Signup routes
      post "sign_up_account_manager" => "sign_up#sign_up_account_manager",
         :as => "sign_up_account_manager"
      post "admin_confirmation/:id/confirm_code/:code" => "sign_up#confirm_administrator_account",
        :as => "confirm_administrator_account"
      get "org_admin/:id/confirm_code/:code" => "sign_up#show_valid_admin", as: "show_valid_admin"

     	# Nested Org routes
      resources :organisation do
        resources :student, :type => "Student"
        post '/import_users' => 'student#import', as: :import_users
        post '/import_admins' => 'org_admin#import', as: :import_admins
        resources :org_admin, :type => "OrgAdmin", as: :admin
        resources :activities
      end

      # Standard routes
      resources :org_admin, :type => "OrgAdmin"
      resources :app_admin, :type => "AppAdmin"
      resources :student, :type => "Student"
      resources :activities

    end

  end
end
