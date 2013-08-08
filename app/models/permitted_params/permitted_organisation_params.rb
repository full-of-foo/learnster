class PermittedOrganisationParams < Struct.new(:params, :organisation)
  
  def organisation
    params.require(:topic).permit(*organisation_attributes)
  end

  def organisation_attributes
    attrs = [:title, :description, :created_by]
  end

end