attributes :id, :owner, :trackable, :created_at

node do |activity|
    {
        created_ago: time_ago_in_words(activity.created_at()),
        description: render_activity(activity, { display: :i18n })
    }
end

child :owner => :owner do
  attributes :id
  attributes :full_name, :if => lambda { |t| t.class.superclass.name == "User" }
  attributes :title, :if => lambda { |t| t.class.name == "Organisation" }
  node do |owner|
    {
        className: owner.class.name
    }
  end
end

child :trackable => :trackable do
  attributes :id
  attributes :full_name, :if => lambda { |t| t.class.superclass.name == "User" }
  attributes :title, :if => lambda { |t| t.class.name == "Organisation" }
  node do |trackable|
    {
        className: trackable.class.name
    }
  end
end



