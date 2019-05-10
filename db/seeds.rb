# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

80.times do |t|
  User.create(first_name: "#{Faker::Name.first_name}", last_name: "#{Faker::Name.last_name}", email: "fredericmbea@gmail.com#{t}", description: "#{description}", level: "Mid-level", github_link: "https://github.com/frederic92", twitter_link: "https://twitter.com/FredMbea", password: "Alexandre2010", password_confirmation: "Alexandre2010")
end