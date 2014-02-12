attributes :id, :action, :user, :trackable, :created_at


node do |activity|
    {
        created_at_formatted: time_ago_in_words(activity.created_at()),
        action_formatted: activity.action.sub(/e?$/, "ed")
    }
end

child :user => :user do
  attributes :id, :full_name, :type
end

child :trackable => :trackable do
  attributes :id
  node(:name, :if => lambda { |object| object.class.name == "Organisation" ||  object.class.name == "Course" || object.class.name == "LearningModule" }) do |object|
  	object.title
  end
  node(:name, :if => lambda { |object| object.class.name == "CourseSection" }) do |object|
    object.section
  end
  node(:name, :if => lambda { |object| object.class.superclass.name == "User"}) do |object|
  	object.full_name
  end
  node(:trackable_type, :if => lambda { |object| true }) do |object|
  	object.class.name
  end
end

