Fabricator :user do

#  email_address SecureRandom.hex + 'email.com'
  email_address Faker::Internet.email
  full_name     Faker::Name.name
  password      Faker::Internet.password
  
end