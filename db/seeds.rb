###
## == Teardown existing model data then populate
#
#
#


# teardown
[User, OrgAdmin, AppAdmin, Student, Organisation].each(&:delete_all)


# populate 
1.times do |i|
    params = {
        email: "lightweightdevelopment@gmail.com",
        first_name: "Anthony",
        password: "foobar",
        password_confirmation: "foobar",
        surname: "Troy"
    }
    AppAdmin.new(params).save!
end


10.times do |i|
    params = {
        title: Faker::Company.name + "#{i}",
        description: Faker::Lorem.sentence
    }
    Organisation.new(params).save!
end

count = 1

35.times do |i|
    name_gen = Faker::Name

    params = {
        email: "#{i}" + Faker::Internet.email,
        first_name: name_gen.first_name,
        surname: name_gen.last_name,
        password: "fooooooo",
        password_confirmation: "fooooooo",
        last_login: Time.zone.now,
        is_active: false,
        created_by: AppAdmin.first,
        admin_for: Organisation.find(Organisation.first.id + count) 
    }
    count += 1
    count = 1 if count == 10 

    OrgAdmin.new(params).save!
end

Organisation.all.each_with_index do |o, i|
    o.update created_by: OrgAdmin.find(OrgAdmin.first.id + i)
end


90.times do |i|
    name_gen, offset = Faker::Name, rand(Organisation.count)
    rand_org = Organisation.first(:offset => offset)
    offset = rand(rand_org.admins.count)
    rand_admin = rand_org.admins.first(:offset => offset)

    params = {
        email: "#{i}" + Faker::Internet.email,
        first_name: name_gen.first_name,
        surname: name_gen.last_name,
        password: "fooooooo",
        password_confirmation: "fooooooo",
        last_login: Time.zone.now,
        is_active: false,
        attending_org: rand_org,
        created_by: rand_admin
    }
    
    s = Student.new(params).save!
end