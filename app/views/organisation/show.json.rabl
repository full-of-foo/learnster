object @organisation

child :admins => :admins do
  attributes :id, :email, :first_name, :surname, :full_name, :is_active
end

extends "organisation/_base"

child :students => :students do
  attributes :id, :email, :first_name, :surname, :full_name, :is_active
end