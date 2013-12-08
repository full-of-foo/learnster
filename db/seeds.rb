###
## == Teardown existing model data then populate
#
#
#

# teardown
[Activity, User, OrgAdmin, AppAdmin, Student, Organisation].each(&:delete_all)


# populate 
1.times do |i|
    params = {
        email: "lightweightdevelopment@gmail.com",
        first_name: "Anthony",
        password: "foobar",
        password_confirmation: "foobar",
        surname: "Troy"
    }
    AppAdmin.new(params).save
end

# 1.times do |i|
#     params = {
#         email: "doo@gmail.com",
#         first_name: "sddsf",
#         surname: "sddsf",
#         password: "fooooooo",
#         password_confirmation: "fooooooo",
#         last_login: Time.zone.now,
#         is_active: false
#     }
#     oa = OrgAdmin.new(params)
#     oa.save(:validate => false)
# end


10.times do |i|
    params = {
        title: Faker::Company.name + "#{i}",
        description: Faker::Lorem.sentence,
        created_at: rand(10.years).ago
        # created_by: OrgAdmin.first
    }
    o = Organisation.new(params)
    o.save
    # OrgAdmin.first.activities.create! action: "create", trackable: o
end

count = 0

35.times do |i|
    name_gen = Faker::Name

    if count == 0
        orgId = Organisation.first.id
    else
        orgId = Organisation.first.id + count
    end

    params = {
        email: "#{i}" + Faker::Internet.email,
        first_name: name_gen.first_name,
        surname: name_gen.last_name,
        password: "fooooooo",
        password_confirmation: "fooooooo",
        last_login: Time.zone.now,
        is_active: false,
        created_by: AppAdmin.first,
        admin_for: Organisation.find(orgId),
        created_at: rand(3.years).ago,
        updated_at: rand(2.years).ago
    }
    count += 1
    count = 0 if count == 10

    oa = OrgAdmin.new(params)
    oa.save
    AppAdmin.first.activities.create! action: "create", trackable: oa
end

Organisation.all.each_with_index do |o, i|
    if i == 0
        index = OrgAdmin.first.id
    else
        index = OrgAdmin.first.id + i
    end
    o.update created_by: OrgAdmin.find(index)
    AppAdmin.first.activities.create! action: "update", trackable: o
end


90.times do |i|
    name_gen, offset = Faker::Name, rand(Organisation.count)
    rand_org = Organisation.first(:offset => offset)

    params = {
        email: "#{i}" + Faker::Internet.email,
        first_name: name_gen.first_name,
        surname: name_gen.last_name,
        password: "fooooooo",
        password_confirmation: "fooooooo",
        last_login: Time.zone.now,
        is_active: false,
        attending_org: rand_org,
        created_by: AppAdmin.first,
        created_at: rand(5.years).ago,
    }
    s = Student.new(params)
    s.save
    s.activities.create! action: "update", trackable: rand_org
end

count = 1

Student.all.each do |s|
    s.update created_by: s.attending_org.admins.first, updated_at: rand(1.years).ago

    count += 1
    count = 1 if count == 34    
end

Student.first.update(email: "student@foo.com", password: "foobar")
OrgAdmin.first.update(email: "admin@foo.com", password: "foobar")
