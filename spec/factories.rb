# sequence(:random_string) {|n| LoremIpsum.generate }

FactoryGirl.define do
  factory :super_admin, class: User do

    first_name "JoeSuper"
    surname "Blogs"
    sequence(:email) { |n| "foo1@example.com" }
    type "AppAdmin"
    salt "asdasdastr4325234324sdfds"
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("foobar", "asdasdastr4325234324sdfds")
    password "foobar"
    password_confirmation "foobar"
    
  end

  factory :admin, class: User do

    first_name "JoeOrgAdmin"
    surname "Blogs"
    sequence(:email) { |n| "foo2@example.com" }
    type "OrgAdmin"
    salt "asdasdastr4325234324sfooo"
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("foobar", "asdasdastr4325234324sfooo")
    password "foobar"
    password_confirmation "foobar"
    
  end

  factory :student, class: User do

    first_name "JoeStudent"
    surname "Blogs"
    sequence(:email) { |n| "foo3@example.com" }
    type "Student"
    salt "asdasdastr4325234324sdbar"
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("foobar", "asdasdastr4325234324sdbar")
    password "foobar"
    password_confirmation "foobar"
    
  end
end 