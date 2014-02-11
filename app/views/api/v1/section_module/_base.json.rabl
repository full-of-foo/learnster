attributes :id, :learning_module, :course_section

child :learning_module => :learning_module do
  attributes :id, :title, :description, :created_at, :updated_at, :educator_id
end

child :course_section => :course_section do
  attributes :id, :section, :created_at, :updated_at
end
