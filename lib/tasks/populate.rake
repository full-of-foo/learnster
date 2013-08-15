namespace :db do
    desc "Erase and populate DB...."
    task :populate => :environment do
        require "populator"

        [User, Organisation].each(&:delete_all)

        User.populate 20 do |u|
            u.email = Faker::Internet.email
            name_gen = Faker::Name
            u.first_name = name_gen.first_name
            u.surname = name_gen.last_name
        end

        Organisation.populate 10 do |o|
            o.title = Faker::Company.name
            o.description = Faker::Lorem.sentence
        end
    end
end