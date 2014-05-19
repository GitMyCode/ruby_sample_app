namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "example",
                 email: "test@test.com" ,
                 password: "qwerty",
                 password_confirmation: "qwerty",
                 admin: true)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@email.com"
      password = "password"
      User.create!(name: name,
                   email: email,
                  password: password ,
                  password_confirmation: password)
    end
  end
end