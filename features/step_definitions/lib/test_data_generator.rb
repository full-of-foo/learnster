module TestDataGenerator
  require 'faker'
  Faker::Config.locale = :en

  extend self

  def street_address
    Faker::Address::street_address.gsub("'", '')
  end

  def city
    Faker::Address::city.gsub("'", '')
  end

  def title
    Faker::Company.name.gsub("'", '')
  end

  def description
    Faker::Lorem.words(4..10).join(" ").gsub("'", '')
  end

  def full_name
    "0#{Faker::Internet::user_name.gsub("'", '').gsub(/-/, ".")}"
  end

  def first_name
    Faker::Name::first_name.gsub("'", '')
  end

  def last_name
    Faker::Name::last_name.gsub("'", '')
  end

  def lorem_word
    "0#{Faker::Lorem::word.gsub("'", '').capitalize!}#{Time.now.strftime("%T")}"
  end

  def email
    Faker::Internet.email
  end

  def price
    sprintf("%0.2f", 300.0 * rand()).gsub(/\.[0-9]0|\.0[0-9]/, '')
  end
end
