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
  end

end
