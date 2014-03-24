require 'csv'
require 'faker'

headers = ['email', 'first_name', 'surname', 'password']
data = []

CSV.open("csv_examples/users.csv", "wb") do |csv|
  csv << headers

  20.times { |i|
    row = [Faker::Internet.email, Faker::Name.first_name, Faker::Name.last_name, 'foobar']
    data << row
    csv << row
  }
end

puts "CSV data: #{data}"
