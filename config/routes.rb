Learnster::Application.routes.draw do

  root to:"application#index"

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
