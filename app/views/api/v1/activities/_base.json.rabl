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
  attributes :title, :if => lambda { |object| object.class.name == "Organisation" }
  attributes :full_name, :type, :if => lambda { |object| object.class.superclass.name == "User" }
end

