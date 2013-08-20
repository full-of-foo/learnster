class FixUserAttendsOrgColName < ActiveRecord::Migration
  def change
  	rename_column  :users, :attending_orgs, :attending_org
  end
end
