object @organisation

extends "api/v1/organisation/_base"

child :admins => :admins do
  attributes :id, :email, :first_name, :surname, :full_name, :is_active
end

child :students => :students do
  attributes :id, :email, :first_name, :surname, :full_name, :is_active
end
