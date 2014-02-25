attributes :id, :title, :description, :created_at, :updated_at, :file_upload, :module_supplement

node do |supplement_content|
    {
        created_at_formatted: supplement_content.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(supplement_content.updated_at())
    }
end

child :module_supplement => :module_supplement do
  attributes :id, :title, :description, :created_at, :updated_at, :learning_module

  child :learning_module => :learning_module do
    attributes :id, :title, :educator_id
  end
end

child :file_upload => :file_upload do
  attributes :url
end
