Learnster::Application.routes.draw do


  ##
  # Auth routes
  devise_for :users, :path => '', :path_names => { 
    :sign_in => 'login', :sign_out => 'logout'
  }, controllers: {
    sessions:  "devise_overrides/sessions"
  }

  devise_scope :user do
    get 'current_user' => 'sessions#show_current_user', :as => 'show_current_user'
  end

  ##
  # App routes
  scope "app" do
    get "", :to => "application#index", :as => :app_route
  end

  root "application#index"

  ##
  # API routes
  scope "api" do
     resources :organisation do
      resources :student, :type => "Student"
      resources :admin, :controller => "org_admin", :type => "OrgAdmin"
    end
    resources :org_admin, :type => "OrgAdmin"
    resources :app_admin, :type => "AppAdmin"
    resources :student, :type => "Student"
  end

end
