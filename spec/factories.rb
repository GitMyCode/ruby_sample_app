FactoryGirl.define do
  factory :user do
    name  'Michael Hartl'
    email 'foobar@email.com'
    password 'foobar'
    password_confirmation 'foobar'
  end
end