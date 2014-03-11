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
      post "org_admin/:id/sign_up_organisation/confirm_code/:code" => "sign_up#sign_up_organisation",
         :as => "sign_up_organisation"
      post "auth_administrator_account" => "sign_up#auth_administrator_account", :as => "auth_administrator_account"
      post "admin_confirmation/:id/confirm_code/:code" => "sign_up#confirm_administrator_account",
        :as => "confirm_administrator_account"

     	# Nested Org routes
      resources :organisation do
        resources :student, :type => "Student"
        post '/import_users' => 'student#import', as: :import_users
        post '/import_admins' => 'org_admin#import', as: :import_admins
        resources :org_admin, :type => "OrgAdmin", as: :admin
        resources :activities
        resources :course
        resources :course_section
        resources :learning_module
        resources :section_module
        resources :module_supplement
        resources :supplement_content
        resources :content_upload
        resources :submission_upload
        resources :wiki_content
        resources :wiki_submission
        resources :deliverable
        resources :submission
        get '/course/:course_id/course_section' => 'course_section#index'
        get '/course_section/:course_section_id/learning_module' => 'learning_module#index'
      end

      # Standard routes
      resources :org_admin, :type => "OrgAdmin"
      resources :app_admin, :type => "AppAdmin"
      resources :student, :type => "Student"
      resources :activities
      resources :course
      resources :course_section
      resources :learning_module
      resources :section_module
      resources :module_supplement
      resources :supplement_content
      resources :content_upload
      resources :submission_upload
      resources :wiki_content
      resources :wiki_submission
      post "/wiki_submission/version/:id/revert" => "wiki_submission#revert", as: :wiki_submission_revert
      get "/wiki_submission/:id/versions" => "wiki_submission#index_versions", as: :wiki_submission_versions
      get "/wiki_submission/:id/version" => "wiki_submission#show_version", as: :wiki_submission_version
      resources :enrolled_course_section
      resources :deliverable
      resources :submission
    end

  end
end
