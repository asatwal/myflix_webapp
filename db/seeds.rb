# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedies = Category.create(name: 'TV Comedies')

dramas = Category.create(name: 'TV Dramas')

reality_tv = Category.create(name: 'Reality TV')


Video.create(title: 'Family Guy', description: 'About a Family Guy', 
             small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/family_guy.jpg', category: comedies)

Video.create(title: 'Futurama', description: 'About the Future', 
             small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama.jpg', category: comedies)


Video.create(title: 'Family Guy', description: 'About a Family Guy', 
             small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/family_guy.jpg', category: comedies)

Video.create(title: 'Futurama', description: 'About the Future', 
             small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama.jpg', category: comedies)


Video.create(title: 'Monk', description: 'About a monk', 
             small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: comedies)


Video.create(title: 'South Park', description: "Animated comedy from the 1990's", 
             small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/south_park.jpg', category: comedies)


Video.create(title: 'Monk', description: 'About a monk', 
             small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: comedies)





Video.create(title: 'Monk', description: 'About a monk', 
             small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: dramas)


Video.create(title: 'South Park', description: "Animated comedy from the 1990's", 
             small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/south_park.jpg', category: reality_tv)

