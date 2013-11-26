# sequence(:random_string) {|n| LoremIpsum.generate }

FactoryGirl.define do
  factory :super_admin, class: User do

    first_name "Joe"
    surname "Blogs"
    sequence(:email) { |n| "foo#{n}@example.com" }
    type "AppAdmin"
    password "foobar"
    password_confirmation "foobar"
    
  end
end 