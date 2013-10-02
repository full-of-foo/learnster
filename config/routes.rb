Learnster::Application.routes.draw do


  ##
  # Auth routes
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  root "home#index"


  ##
  # App routes
  scope "app" do
    get "", :to => "application#index", :as => :app_route
  end


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
