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
      get "logout" => "sessions#destroy", :as => "logout"
      post "login" => "sessions#create", :as => "login"

     	# Nested Org routes
      resources :organisation do
        resources :student, :type => "Student"
        resources :org_admin, :type => "OrgAdmin", :as => "admin"
      end

      # Standard routes
      resources :org_admin, :type => "OrgAdmin"
      resources :app_admin, :type => "AppAdmin"
      resources :student, :type => "Student" 
    end
    
  end
end
