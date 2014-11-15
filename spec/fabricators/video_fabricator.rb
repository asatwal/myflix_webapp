
Fabricator :video do

  title           Faker::Lorem.words(5).join(' ')
  description     Faker::Lorem.paragraphs(2).join(' ')
  small_cover     {Faker::Lorem.word + '.jpg'}
  large_cover     {Faker::Lorem.word + '.jpg'}
  video_url       Faker::Internet.url
  
end

