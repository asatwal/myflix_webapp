
Fabricator :video do

  title           Faker::Lorem.words(5).join(' ')
  description     Faker::Lorem.paragraphs(2).join(' ')
  small_cover_url Faker::Internet.url
  large_cover_url Faker::Internet.url
  
end


