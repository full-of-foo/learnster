require 'api_constraints'

Learnster::Application.routes.draw do

  # App routes
  scope "app" do
    get "", :to => "application#index", :as => :app_route
  end

  root "application#index"


  # API routes
  namespace "api", defaults: {format: 'json'} do
    
    # Default API version
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      # Aut routes
      devise_for :users, :path => '', :path_names => { 
        :sign_in => 'login', :sign_out => 'logout'
        }, controllers: {
          sessions:  "api/v1/devise_overrides/sessions",
          registrations:  "api/v1/devise_overrides/registrations"
        }

      # Nested Org routes
      resources :organisation do
        resources :student, :type => "Student"
        resources :admin, :type => "OrgAdmin"
      end

      # Standard routes
      resources :org_admin, :type => "OrgAdmin"
      resources :app_admin, :type => "AppAdmin"
      resources :student, :type => "Student" 
    end
    
  end
end
