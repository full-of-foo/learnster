FactoryGirl.define do

  factory :user, class: User do
    sequence(:email){|n| "base#{n}@noncompany.no" }
    first_name "Base"
    surname "McUser"

    password "foobar"
    password_confirmation "foobar"
  end

  factory :app_admin, class:  AppAdmin, parent: :user do
    sequence(:email){|n| "superadmin#{n}@learnster.ie" }
    first_name "Tony"
    surname "Cool"
  end

  factory :org_admin, class:  OrgAdmin, parent: :user do
    sequence(:email){|n| "admin#{n}@dit.ie" }
    first_name "John"
    surname "McSystemadmin"

    trait :dcu do
      sequence(:email){|n| "admin#{n}@dcu.ie" }
    end
    trait :dit do end
  end

  factory :student, class:  Student, parent: :user  do
    sequence(:email){|n| "student#{n}@dit.ie" }
    first_name "Billy"
    surname "McStudent"
    association :attending_org, factory: :organisation

    trait :dcu do
      sequence(:email){|n| "student#{n}@dcu.ie" }
    end
    trait :dit do end
  end

  factory :organisation, class:  Organisation do
    sequence(:title){|n| "Dublin Institute of Technology #{n}" }
    description "A third-level institute based at the heart of Dublin city. \
                          Passionate about delivering an excellent learning experience"
    created_at Date.today
    association :created_by, factory: :org_admin

    trait :dcu do
      sequence(:title){|n| "Dublin City University #{n}" }
    end
    trait :dit do end
  end

  factory :course, class: Course do
    title "Information Systems Development BSc"
    description "Level 8 undergraudate degree exploring the disciplines\
                          concerning both business science and computer science, with the an \
                          emphasis on business proccess management and software engineering"
    identifier "DT354"
    organisation
    association :managed_by, factory: :org_admin

    trait :dcu do
      association :organisation, :factory => [:organisation, :dcu]
      association :managed_by, :factory => [:org_admin, :dcu]
    end
    trait :dit do end
  end

  factory :course_section, class: CourseSection do
    section "1st Year"
    association :course, factory: :course
    association :provisioned_by, factory: :org_admin

    trait :dcu do
      association :course, :factory => [:course, :dcu]
      association :provisioned_by, :factory => [:org_admin, :dcu]
    end
    trait :dit do end
  end

  factory :enrollment, class: EnrolledCourseSection do
    association :student, factory: :student
    association :course_section, factory: :course_section

    trait :dcu do
      association :student, :factory => [:student, :dcu]
      association :course_section, :factory => [:course_section, :dcu]
    end
    trait :dit do end
  end

  factory :module, class: LearningModule do
    title "Object Orientated Programming 1"
    description "Introductory one-year module in software development in an\
                          object oriented environment using Java"
    association :educator, factory: :org_admin
    association :organisation, factory: :organisation

    trait :dcu do
      title "Basic Statistics"
      description "Covers a wide range of topics in around using inferential statistics"
      association :educator, :factory => [:org_admin, :dcu]
      association :organisation, :factory => [:organisation, :dcu]
    end
    trait :dit do end
  end

  factory :section_module, class: SectionModule do
    association :learning_module, factory: :module
    association :course_section, factory: :course_section

    trait :dcu do
      association :learning_module, :factory => [:module, :dcu]
      association :course_section, :factory => [:course_section, :dcu]
    end
    trait :dit do end
  end

  factory :module_supplement, class: ModuleSupplement do
    title "Lesson 1"
    association :learning_module, factory: :module

    trait :dcu do
      association :learning_module, :factory => [:module, :dcu]
    end
    trait :dit do end
  end

  factory :deliverable, class: Deliverable do
    title "Assignment 1"
    due_date Date.today
    association :module_supplement, factory: :module_supplement

    trait :dcu do
      association :module_supplement, :factory => [:module_supplement, :dcu]
    end
    trait :dit do end
  end

  factory :supplement_content, class: SupplementContent do
    title "Class wiki"
    association :module_supplement, factory: :module_supplement

    trait :dcu do
      association :module_supplement, :factory => [:module_supplement, :dcu]
    end
    trait :dit do end
  end

  factory :content_upload, class: ContentUpload, parent: :supplement_content do
    file_upload ActionDispatch::Http::UploadedFile.new(tempfile: File.new("#{Rails.root}/public/favicon.ico"), filename: "favicon.ico")

    trait :dcu do end
    trait :dit do end
  end

  factory :wiki_content, class: WikiContent, parent: :supplement_content do
    wiki_markup "<div>I could not complete this deliverable :(</div>"

    trait :dcu do end
    trait :dit do end
  end

  factory :submission, class: Submission do
    association :student, factory: :student
    association :deliverable, factory: :deliverable

    trait :dcu do
      association :student, :factory => [:student, :dcu]
      association :deliverable, :factory => [:deliverable, :dcu]
    end
    trait :dit do end
  end

  factory :submission_upload, class: SubmissionUpload, parent: :submission do
    file_upload ActionDispatch::Http::UploadedFile.new(tempfile: File.new("#{Rails.root}/public/favicon.ico"), filename: "favicon.ico")

    trait :dcu do end
    trait :dit do end
  end

  factory :wiki_submission, class: WikiSubmission, parent: :submission do
    wiki_markup "<div>I could not complete this deliverable :(</div>"

    trait :dcu do end
    trait :dit do end
  end

  factory :api_key, class: ApiKey do
    association :user, factory: :user
  end

  factory :activity, class: Activity do
    association :user, factory: :user

    %w(module deliverable course course_section submission wiki_submission wiki_content
            content_upload supplement_content submission_upload section_module enrollment).each do | factory |
      trait "dcu_#{factory}".to_sym do
        association :trackable, factory: [factory.to_sym, :dcu]
      end
      trait "dit_#{factory}".to_sym do
        association :trackable, factory: [factory.to_sym, :dcu]
      end
    end

  end

end
