###
## == Teardown existing model data then populate
#
#
#

# teardown
[ApiKey, LearningModule, User, Organisation, Activity,
  EnrolledCourseSection, CourseSection, Course, SupplementContent,
  ModuleSupplement, Deliverable, Submission, PaperTrail::Version]
    .each(&:delete_all)

########################
## Users and Orgs
########################


# system admin
app_admin = AppAdmin.new(email: "lightweightdevelopment@gmail.com",
                         first_name: "Foo",
                         password: "foobar",
                         password_confirmation: "foobar",
                         surname: "McSystemadmin")
app_admin.save!


# account creators
dit_super_admin = OrgAdmin.new(email: "superadmin@dit.ie",
                                first_name: "Anthony",
                                surname: "Troy",
                                password: "foobar",
                                password_confirmation: "foobar",
                                last_login: Time.zone.now,
                                is_active: false,
                                created_at: rand(3.years).ago,
                                updated_at: rand(2.years).ago,
                                role: "account_manager")
boi_super_admin = OrgAdmin.new(email: "superadmin@boi.ie",
                                first_name: "Anthony",
                                surname: "Troy",
                                password: "foobar",
                                password_confirmation: "foobar",
                                last_login: Time.zone.now,
                                is_active: false,
                                created_at: rand(3.years).ago,
                                updated_at: rand(2.years).ago,
                                role: "account_manager")
dit_super_admin.save!
boi_super_admin.save!


# organisations
dit =  Organisation.new(title: "Dublin Institute of Technology",
                        description: "A third-level institute based at the heart\
                          of Dublin city. Passionate about delivering an excellent learning\
                          experience",
                        created_at: rand(10.years).ago)
boi = Organisation.new(title: "Bank of Ireland",
                       description: "dedicated to providing people and businesses with the\
                        financial help they need to make the most of life's opportunities",
                       created_at: rand(10.years).ago)


# register account holders and organisations
dit_super_admin.update!(confirmed: true)
boi_super_admin.update!(confirmed: true)

dit.created_by = dit_super_admin
boi.created_by = boi_super_admin

dit.save!
boi.save!

dit.admins.push dit_super_admin
boi.admins.push boi_super_admin


# import admins/educators
dit_mock_admin_upload_file = ActionDispatch::Http::UploadedFile.new({
  filename:     'dit-admin.seeds.csv',
  content_type: 'application/vnd.ms-excel',
  tempfile:     File.new("#{Rails.root}/csv_examples/dit-admin.seeds.csv")
})
boi_mock_admin_upload_file = ActionDispatch::Http::UploadedFile.new({
  filename:     'dit-admin.seeds.csv',
  content_type: 'application/vnd.ms-excel',
  tempfile:     File.new("#{Rails.root}/csv_examples/boi-admin.seeds.csv")
})
OrgAdmin.import_with_validation(dit_mock_admin_upload_file, dit, dit_super_admin)
OrgAdmin.import_with_validation(boi_mock_admin_upload_file, boi, boi_super_admin)


# import students
dit_mock_student_upload_file = ActionDispatch::Http::UploadedFile.new({
  filename:     'dit-student.seeds.csv',
  content_type: 'application/vnd.ms-excel',
  tempfile:     File.new("#{Rails.root}/csv_examples/dit-student.seeds.csv")
})
boi_mock_student_upload_file = ActionDispatch::Http::UploadedFile.new({
  filename:     'dit-student.seeds.csv',
  content_type: 'application/vnd.ms-excel',
  tempfile:     File.new("#{Rails.root}/csv_examples/boi-student.seeds.csv")
})
Student.import_with_validation(dit_mock_student_upload_file, dit, dit_super_admin)
Student.import_with_validation(boi_mock_student_upload_file, boi, boi_super_admin)


# courses
dit_paddy_admin = OrgAdmin.find_by(email: 'paddy@dit.ie')
info_dev_course = Course.new(organisation: dit,
                              managed_by: dit_paddy_admin,
                              title: "Information Systems Development BSc",
                              description: "Level 8 undergraudate degree exploring the disciplines\
                              concerning both business science and computer science, with the an \
                               emphasis on business proccess management and software engineering",
                              identifier: "DT354")
info_dev_course.save!
dit_paddy_admin.activities.create! trackable: info_dev_course, action: "create"
boi_paddy_admin        = OrgAdmin.find_by(email: 'paddy@boi.ie')
beginners_excel_course = Course.new(organisation: boi,
                              managed_by: boi_paddy_admin,
                              title: "Excel Skills",
                              description: "introduces you to the power of Microsoft Excel starting \
                              from the beginning. You’ll learn how to open/close files, how to \
                              enter formulae into a cell, build basic charts and format a spreadsheet",
                              identifier: "Excel101")
beginners_excel_course.save!
boi_paddy_admin.activities.create! trackable: beginners_excel_course, action: "create"


# course sections
info_dev_sections = ["1st Year - Semester 1", "1st Year - Semester 2", "2nd Year - Semester 1"]
info_dev_sections.each do |section_title|
  section = CourseSection.new(course: info_dev_course,
                              provisioned_by: dit_paddy_admin,
                              section: section_title)
  section.save!
  dit_paddy_admin.activities.create! trackable: section, action: "create"
end

excel_sections = ['Excel Foundation Skills - May', 'Excel Essential Skills - June']
excel_sections.each do |section_title|
  section = CourseSection.new(course: beginners_excel_course,
                              provisioned_by: boi_paddy_admin,
                              section: section_title)
  section.save!
  boi_paddy_admin.activities.create! trackable: section, action: "create"
end

# learning modules
info_dev_first_semester_module_params = [
  { title:       "Object Orientated Programming 1",
    description: "Introductory one-year module in software development in an\
     object oriented environment using Java",
    educator: OrgAdmin.find_by(email: 'mary@dit.ie'),
    organisation: dit },
  { title:       "Basic Statistics",
    description: "Covers a wide range of topics in introductory statistical presentation and analysis",
    educator:    OrgAdmin.find_by(email: 'aongus@dit.ie'),
    organisation: dit },
  { title:       "Principles of Management",
    description: "Introduces what the management function does, and why it relevant in the revenue\
     generation process of an organisation",
    educator:    OrgAdmin.find_by(email: 'hugh@dit.ie'),
    organisation: dit }
]
info_dev_second_semester_module_params = [
  { title:       "Object Orientated Programming 2",
    description: "Focusses on the construction of Graphical User Interfaces to software applications,\
     and introducing them to the notion of usability",
    educator: OrgAdmin.find_by(email: 'don@dit.ie'),
    organisation: dit },
  { title:       "Inferential Statistics",
    description: "Provides a range of statistical tools to enable them to formulate statistical hypotheses\
     and to rigorously test these hypotheses",
    educator:    OrgAdmin.find_by(email: 'hugh@dit.ie'),
    organisation: dit },
  { title:       "Database Fundementals",
    description: "Applies database theory by implementing a solution to a business problem using a\
     current database product",
    educator:    OrgAdmin.find_by(email: 'audery@dit.ie'),
    organisation: dit }
]

excell_foundation_module_params = [
   { title:      "Introduction to Excel",
    description: "Focusses on the basic concepts around using Excel",
    educator: OrgAdmin.find_by(email: 'ian@boi.ie'),
    organisation: boi }
]
excell_essential_module_params = [
   { title:      "Intermidiate Excel",
    description: "Teaches advanced Excel tasks such as custome macros",
    educator: OrgAdmin.find_by(email: 'ian@boi.ie'),
    organisation: boi }
]

module_params = (info_dev_first_semester_module_params + info_dev_second_semester_module_params +
                 excell_foundation_module_params + excell_essential_module_params)
module_params.each do |module_params|
  learning_module = LearningModule.new(module_params)
  learning_module.save!
  learning_module.educator.activities.create! trackable: learning_module, action: "create"
end

# assign modules to sections
info_dev_first_semester  = CourseSection.find_by(section: "1st Year - Semester 1")
info_dev_second_semester = CourseSection.find_by(section: "1st Year - Semester 2")
excel_foundation_section = CourseSection.find_by(section: "Excel Foundation Skills - May")
excel_essential_section  = CourseSection.find_by(section: "Excel Essential Skills - June")

info_dev_first_semester_module_params.each do |module_params|
  learning_module = LearningModule.find_by(title: module_params[:title])
  learning_module.course_sections << info_dev_first_semester
end
info_dev_second_semester_module_params.each do |module_params|
  learning_module = LearningModule.find_by(title: module_params[:title])
  learning_module.course_sections << info_dev_second_semester
end
excell_foundation_module_params.each do |module_params|
  learning_module = LearningModule.find_by(title: module_params[:title])
  learning_module.course_sections << excel_foundation_section
end
excell_essential_module_params.each do |module_params|
  learning_module = LearningModule.find_by(title: module_params[:title])
  learning_module.course_sections << excel_essential_section
end


# enroll first year students
dit_students = dit.students
dit_students.each do |student|
  EnrolledCourseSection.create!(course_section: info_dev_first_semester, student: student)
end


# enroll all boi students to both sections
boi_students = boi.students
boi_students.each do |student|
  EnrolledCourseSection.create!(course_section: excel_essential_section, student: student)
  EnrolledCourseSection.create!(course_section: excel_foundation_section, student: student)
end

# supplments/lessons/weeks
oo_module               = LearningModule.find_by(title: "Object Orientated Programming 1")
stats_module            = LearningModule.find_by(title: "Basic Statistics")
db_module               = LearningModule.find_by(title: "Database Fundementals")
excel_foundation_module = LearningModule.find_by(title: "Introduction to Excel")

oo_weeks_params = [
  { title: "Week 1",
    description: "Introduction to the basic concepts of computer programming and modularization",
    learning_module: oo_module },
  { title: "Week 2",
    description: "Creating your first 'hello world' application",
    learning_module: oo_module },
  { title: "Week 3",
    description: "Introduction to objects and classes",
    learning_module: oo_module },
  { title: "Week 4",
    description: "Introduction to langauges and object-orientation",
    learning_module: oo_module }
]

stats_weeks_params = [
  { title: "Week 1 - intro",
    description: "Basic concepts around statistics and their application both enterprise and\
     computing",
    learning_module: stats_module },
  { title: "Week 2 - averages",
    description: "Exploring mean, mode and median",
    learning_module: stats_module },
  { title: "Week 3 - distribution",
    description: "Introduction to standard deviation and distributions",
    learning_module: stats_module }
]

db_weeks_params = [
  { title: "Week 1 - what is data?",
    description: "Exploring the concept of data and its importance",
    learning_module: db_module },
  { title: "Week 2 - schemas vs tables",
    description: "Introduction to relational schemas and tables",
    learning_module: db_module },
  { title: "Week 3 - CRUD",
    description: "Considering DB operations and relations",
    learning_module: db_module }
]

excel_weeks_params = [
  { title: "Week 1 - Getting Started",
    description: "General introduction to the Excel environment and basic Excel concepts",
    learning_module: excel_foundation_module },
  { title: "Week 2 - First Document",
    description: "Creating your first Excel document while learning the different file types\
     that exist",
    learning_module: excel_foundation_module },
  { title: "Week 3 - Document formating",
    description: "Introduction to cell and document formating in Excel",
    learning_module: excel_foundation_module },
  { title: "Week 4 - Excel Formulae",
    description: "Introduction to the concept and implementation of Excel formulas",
    learning_module: excel_foundation_module }
]

supplments_params = (excel_weeks_params + oo_weeks_params + stats_weeks_params +
                      db_weeks_params)
supplments_params.each do |params|
  lesson = ModuleSupplement.new(params)
  lesson.save!
  lesson.learning_module.educator.activities.create! trackable: lesson, action: "create"
end


# content uploads - slides for each lesson
ModuleSupplement.all.each do |supplment|
  content_upload = ContentUpload.new(title: "#{supplment.title} - Lesson Slides",
                                    remote_file_upload_url: "https://news.ycombinator.com/y18.gif",
                                    module_supplement: supplment)
  content_upload.save!
  supplment.learning_module.educator
    .activities.create! trackable: content_upload, action: "create"
end


# deliverables and wiki submissions - project for each last lesson
LearningModule.all.each do |learning_module|
  lesson = learning_module.module_supplements.last if !learning_module.module_supplements.empty?

  if lesson
    deliverable = Deliverable.new(title: "#{lesson.title} - Final Project",
                                  due_date: (Time.zone.now + 1.week),
                                  is_private: false,
                                  module_supplement: lesson)
    deliverable.save!
    learning_module.educator.activities
      .create! trackable: deliverable, action: "create"

    students = Student.module_students(learning_module.id).each do |student|
      params = {
        notes: "My first draft of #{deliverable.title}",
        wiki_markup: "<h1>Trololoolololo</h2><p>...I'm stuck!</p>",
        student: student,
        deliverable: deliverable
      }
      wiki_sub = WikiSubmission.new(params)
      wiki_sub.save!
      student.activities.create! trackable: wiki_sub, action: "create"
    end

  end
end
