# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.where(email: "admin@gmail.com", is_admin: true).first
unless admin
  User.create(first_name: "admin", last_name: "user", email: "admin@gmail.com", password: 123456, is_admin: true, is_verified: true)
end
