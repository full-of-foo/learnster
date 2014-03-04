attributes :id, :title, :description, :type, :due_date, :is_closed, :is_private, :created_at, :updated_at, :module_supplement

node do |deliverable|
    {
        created_at_formatted: deliverable.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(deliverable.updated_at()),
        due_date_formatted: deliverable.due_date.strftime("%d/%m/%Y")
    }
end

child :module_supplement => :module_supplement do
  attributes :id, :title, :description, :created_at, :updated_at, :learning_module

  child :learning_module => :learning_module do
    attributes :id, :title, :educator_id
  end
end
