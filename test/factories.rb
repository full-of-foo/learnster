FactoryGirl.define do

  factory :org_admin, class:  OrgAdmin do
    sequence(:email){|n| "admin#{n}@dit.ie" }
    first_name "John"
    password "foobar"
    password_confirmation "foobar"
    surname "McSystemadmin"
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
  end

  factory :course, class: Course do
    title "Information Systems Development BSc"
    description "Level 8 undergraudate degree exploring the disciplines\
                          concerning both business science and computer science, with the an \
                          emphasis on business proccess management and software engineering"
    identifier "DT354"
    organisation
    association :managed_by, factory: :org_admin
  end

  factory :course_section, class: CourseSection do
    section "1st Year"
    association :course, factory: :course
    association :provisioned_by, factory: :org_admin
  end

  factory :enrollment, class: EnrolledCourseSection do
    association :student, factory: :student
    association :course_section, factory: :course_section
  end

end
