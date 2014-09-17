
Fabricator :review do

  transient        :user_id, :video_id

  comment          Faker::Lorem.paragraphs(2).join(' ')
  rating           3
  user_id          { |attrs| attrs[:user_id] }
  reviewable_id    { |attrs| attrs[:video_id] }
  reviewable_type 'Video'
end