attributes :id, :notes, :type, :created_at, :updated_at, :file_upload, :wiki_markup, :deliverable, :student, :version

node do |submission|
    {
        created_at_formatted: submission.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(submission.updated_at())
    }
end

node(:word_count, :if => lambda { |object| object.class.name == "WikiSubmission" }) do |object|
    object.wiki_word_count()
end

child :deliverable => :deliverable do
  attributes :id, :title, :description, :due_date, :is_closed, :is_private, :created_at, :updated_at, :module_supplement

  child :module_supplement => :module_supplement do
    attributes :id, :title, :description, :created_at, :updated_at, :learning_module

    child :learning_module => :learning_module do
      attributes :id, :title, :educator_id
    end
  end
end

child :student => :student do
  attributes :id, :email, :first_name, :surname, :full_name, :type, :is_active, :created_at, :updated_at
end

child :file_upload => :file_upload do
  attributes :url
end

child :version => :version do
  attributes :id, :event
end
