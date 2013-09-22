require "populator"

[User, OrgAdmin, AppAdmin, Student, Organisation].each(&:delete_all)

AppAdmin.populate(1) do |aa|
    aa.email = "lightweightdevelopment@gmail.com"
    aa.first_name = "Anthony"
    aa.surname = "Troy"
    aa.is_active = [true, false].sample
    aa.last_login = rand(2.years).ago
end

Organisation.populate(10) do |o|
    o.title = Faker::Company.name
    o.description = Faker::Lorem.sentence
end

count = 1
OrgAdmin.populate(35) do |oa|
    oa.email = Faker::Internet.email
    name_gen = Faker::Name
    oa.first_name = name_gen.first_name
    oa.surname = name_gen.last_name
    oa.last_login = rand(2.years).ago
    oa.is_active = [true, false].sample
    oa.created_by = AppAdmin.first
    oa.admin_for = Organisation.find(count)
    count += 1
    count = 1 if count == 10
end

Organisation.all.each_with_index do |o, i|
   o.created_by = OrgAdmin.find(OrgAdmin.first.id + i)
   o.save
end



5.times { 
        Student.populate(100) do |u|
        u.email = Faker::Internet.email
        name_gen = Faker::Name
        u.first_name = name_gen.first_name
        u.surname = name_gen.last_name
        u.is_active = [true, false].sample
        u.last_login = rand(2.years).ago
        offset = rand(Organisation.count)
        rand_record = Organisation.first(:offset => offset)
        u.attending_org = rand_record
        u.created_by = u.attending_org.created_by
    end 
}