attributes :id, :email, :first_name, :surname, :full_name, :type, :is_active, :last_login, :created_at, :updated_at


node do |student|
    {
    	last_login_formatted: time_ago_in_words(student.last_login()),
        created_at_formatted: student.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(student.updated_at())
    }
end

child :created_by => :created_by do
  attributes :id, :email, :first_name, :surname, :full_name, :type, :is_active
end

child :attending_org => :attending_org do
  attributes :id, :title, :description
end
