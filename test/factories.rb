FactoryGirl.define do

  factory :org_admin, class:  OrgAdmin do
    sequence(:email){|n| "admin#{n}@dit.ie" }
    first_name "John"
    password "foobar"
    password_confirmation "foobar"
    surname "McSystemadmin"

    trait :dcu do
      sequence(:email){|n| "admin#{n}@dcu.ie" }
    end
    trait :dit do
      sequence(:email){|n| "admin#{n}@dit.ie" }
    end
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
    trait :dit do
      sequence(:title){|n| "Dublin Institute of Technology #{n}" }
    end
  end

  factory :student, class:  Student do
    sequence(:email){|n| "student#{n}@dit.ie" }
    first_name "Billy"
    password "student"
    password_confirmation "student"
    surname "McStudent"
    association :attending_org, factory: :organisation


    trait :dcu do
      sequence(:email){|n| "student#{n}@dcu.ie" }
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
    trait :dit do
      title "Object Orientated Programming 1"
      description "Introductory one-year module in software development in an\
                            object oriented environment using Java"
    end
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

end
