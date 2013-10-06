object @user

extends "api/v1/student/_base", :if => lambda { |u| current_user().student? }
extends "api/v1/org_admin/_base", :if => lambda { |u| current_user().org_admin? }
extends "api/v1/app_admin/_base", :if => lambda { |u| current_user().app_admin? }
