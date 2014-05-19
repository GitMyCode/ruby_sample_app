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

    users = User.find(:all, limit: 6) # pour des besoin de performance
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content)}
    end

  end
end