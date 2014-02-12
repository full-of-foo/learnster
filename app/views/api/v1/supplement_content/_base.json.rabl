attributes :id, :title, :description, :created_at, :updated_at, :module_supplement_id

node do |supplement_content|
    {
        created_at_formatted: supplement_content.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(supplement_content.updated_at())
    }
end

