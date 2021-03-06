# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users:
User.create!( name:                  'Example User',
              email:                 'example@railstutorial.org',
              password:              'foobar',
              password_confirmation: 'foobar',
              admin:                 true,
              activated:             true,
              activated_at:          Time.zone.now )

99.times do |n|
  name     = Faker::Name.name
  email    = "example-#{n+1}@railstutorial.org"
  password = 'password'
  User.create!( name:                  name,
                email:                 email,
                password:              password,
                password_confirmation: password,
                activated:             true,
                activated_at:          Time.zone.now )
end

# Microposts:
users = User.order( :created_at ).take( 6 )
users.each do |user|
  50.times { user.microposts.create!( content: Faker::Lorem.sentence( 5 ) ) }
end

# Followships:
user      = User.first
users     = User.all
users_whom_user_wants_to_follow = users[2..50]
users_who_want_to_follow_user   = users[3..40]
users_whom_user_wants_to_follow.each { |followee| user.follow( followee ) }
users_who_want_to_follow_user.each   { |follower| follower.follow( user ) }
