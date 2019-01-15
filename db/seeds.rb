# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#ユーザーを複数作成する。
#create!は基本はcreateと一緒だが、無効なユーザーだった場合にfalseを
#返すのではなく、例外を発生させる。
User.create!(name: "Example User",
              email: "example@railstutorial.org",
              password:         "foobar",
              password_confirmation: "foobar",
              admin: true)
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password)
end
