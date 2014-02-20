###
## == Teardown existing model data then populate
#
#
#

# teardown
[ApiKey, LearningModule, User, Organisation, Activity,
  EnrolledCourseSection, CourseSection, Course, SupplementContent,
  ModuleSupplement].each(&:delete_all)

########################
## Users and Orgs
########################

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
    description: Faker::Lorem.sentence,
    created_at: rand(10.years).ago
    # created_by: OrgAdmin.first
  }
  o = Organisation.new(params)
  o.save!
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
  oa.save!
  # AppAdmin.first.activities.create! action: "create", trackable: oa
end

Organisation.all.each_with_index do |o, i|
  if i == 0
    index = OrgAdmin.first.id
  else
    index = OrgAdmin.first.id + i
  end
  o.update created_by: OrgAdmin.find(index)
  # AppAdmin.first.activities.create! action: "update", trackable: o
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
  s.save!
  s.activities.create! action: "update", trackable: rand_org
end

count = 1

Student.all.each do |s|
  s.update created_by: s.attending_org.admins.first,
    updated_at: rand(1.years).ago

  count += 1
  count = 1 if count == 34
end

Student.first.update!(email: "student@foo.com", password: "foobar",
  password_confirmation: "foobar", attending_org: Organisation.first)
OrgAdmin.first.update!(email: "admin@foo.com", password: "foobar", role: "account_manager",
  password_confirmation: "foobar", admin_for: Organisation.first)


########################
## Courses
########################

course_org = Organisation.first
course_mgr = course_org.admins.first
course_provisioner = course_org.admins.last
course_students = course_org.students[0..4]

params = {
  organisation: course_org,
  managed_by: course_mgr,
  title: "Information Systems Development BSc",
  description: "Level 8 undergraudate degree exploring the disciplines\
  concerning both business science and computer science, with the an \
   emphasis on business proccess management and software engineering",
  identifier: "DT354"
}
course = Course.new(params)
course.save!


params = {
  course: course,
  provisioned_by: course_provisioner,
  section: "first year - semester 1"
}
course_section = CourseSection.new(params)
course_section.save!

# Enroll students
course_students.each { |s| EnrolledCourseSection
  .create!(course_section: course_section, student: s) }


4.times do |i|
  module_educator = course_org.admins.order("RANDOM()").first
  params = {
    title: "Object Orientated Programming " + "#{i + 1}",
    description: Faker::Lorem.sentence,
    educator: module_educator,
    organisation: course_org
  }
  m = LearningModule.new(params)
  m.save!
  # enroll students
  m.course_sections << course_section

  params = {
    title: "Week #{i + 1}",
    description: Faker::Lorem.sentence,
    learning_module: m
  }
  lesson = ModuleSupplement.new(params)
  lesson.save!

  params = {
    title: "Lecture Slides - part #{i + 1}",
    description: Faker::Lorem.sentence,
    remote_file_upload_url: "https://news.ycombinator.com/y18.gif",
    module_supplement: lesson
  }
  lesson_content = SupplementContent.new(params)
  lesson_content.save!
end

21.times do |i|
    params = {
    organisation: course_org,
    managed_by: course_mgr,
    title: Faker::Company.name + "#{i}",
    description: Faker::Lorem.sentence,
    identifier: Faker::Lorem.word + "#{i}"
  }
  course = Course.new(params)
  course.save!
end

course_count = Course.count
12.times do |i|

  if(i == 0)
    index = Course.first.id
  else
    index = Course.first.id + i
  end

  params = {
    course: Course.find(index),
    provisioned_by: course_provisioner,
    section: Faker::Lorem.word + "#{i}"
  }

  cs = CourseSection.new(params)
  cs.save!
end
