object @user

extends "student/_base", :if => lambda { |u| current_user().student? }
extends "org_admin/_base", :if => lambda { |u| current_user().org_admin? }
extends "app_admin/_base", :if => lambda { |u| current_user().app_admin? }

