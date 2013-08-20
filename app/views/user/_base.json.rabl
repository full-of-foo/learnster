attributes :id, :email, :first_name, :surname, :full_name, :type, :last_login, :created_at, :updated_at


node do |user|
    {
    	last_login_formatted: time_ago_in_words(user.last_login()),
        created_at_formatted: user.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(user.updated_at())
    }
end
