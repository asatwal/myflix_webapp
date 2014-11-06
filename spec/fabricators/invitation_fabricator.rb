
Fabricator :invitation do

  email_address Faker::Internet.email
  full_name     Faker::Name.name
  message       Faker::Lorem.paragraphs(2).join(' ')
end