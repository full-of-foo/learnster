attributes :id, :title, :description, :created_at, :updated_at, :learning_module

node do |module_supplement|
    {
        created_at_formatted: module_supplement.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(module_supplement.updated_at())
    }
end

child :learning_module => :learning_module do
  attributes :id, :title, :description, :created_at, :updated_at, :educator_id, :organisation_id
end
