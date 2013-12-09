module TestDataGenerator
  require 'faker'
  Faker::Config.locale = :en

  def TestDataGenerator.street_address
    Faker::Address::street_address.gsub("'", '') 
  end

  def TestDataGenerator.city
    Faker::Address::city.gsub("'", '')   
  end  

  def TestDataGenerator.title
    Faker::Company.name.gsub("'", '') 
  end 

  def TestDataGenerator.description
    Faker::Lorem.words(4..10).join(" ").gsub("'", '')
  end

  def TestDataGenerator.full_name
    "0#{Faker::Internet::user_name.gsub("'", '').gsub(/-/, ".")}"
  end
  
  def TestDataGenerator.first_name
    Faker::Name::first_name.gsub("'", '')  
  end 

  def TestDataGenerator.last_name
    Faker::Name::last_name.gsub("'", '') 
  end

  def TestDataGenerator.lorem_word
    "0#{Faker::Lorem::word.gsub("'", '').capitalize!}#{Time.now.strftime("%T")}"
  end

  def TestDataGenerator.price
    sprintf("%0.2f", 300.0 * rand()).gsub(/\.[0-9]0|\.0[0-9]/, '')
  end
end
