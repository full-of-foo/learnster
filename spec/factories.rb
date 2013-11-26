# sequence(:random_string) {|n| LoremIpsum.generate }

FactoryGirl.define do
  factory :super_admin, class: User do

    first_name "Joe"
    surname "Blogs"
    sequence(:email) { |n| "foo#{n}@example.com" }
    type "AppAdmin"
    salt "asdasdastr4325234324sdfds"
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("foobar", "asdasdastr4325234324sdfds")
    password "foobar"
    password_confirmation "foobar"
    
  end
end 