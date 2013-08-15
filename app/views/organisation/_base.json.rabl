attributes :id, :title, :description, :created_at, :updated_at


node do |organisation|
    {
        created_at_formatted: organisation.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(organisation.updated_at())
    }
end