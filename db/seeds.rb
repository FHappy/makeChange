# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.all.destroy_all
Donation.all.destroy_all
Charity.all.destroy_all

user1 = User.create(
	username: "user1",
	email: "user1@user.com",
	password: "password"
	)
user2 = User.create(
	username: "user2",
	email: "user2@user.com",
	password: "password"
	)
user3 = User.create(
	username: "user3",
	email: "user3@user.com",
	password: "password"
	)
charity1 = Charity.create(
	ein: 1,
	city: "city",
	state: "state",
	zip_code: "11111",
	category: "cat",
	name: "charity1",
	url: "http://www.google.com",
	mission_statement: "mission_statement"
	)
charity2 = Charity.create(
	ein: 2,
	city: "city",
	state: "state",
	zip_code: "22222",
	category: "cat",
	name: "charity2",
	url: "http://www.google.com",
	mission_statement: "mission_statement"
	)
charity3 = Charity.create(
	ein: 3,
	city: "city",
	state: "state",
	zip_code: "33333",
	category: "cat",
	name: "charity3",
	url: "http://www.google.com",
	mission_statement: "mission_statement"
	)
charity4 = Charity.create(
	ein: 4,
	city: "city",
	state: "state",
	zip_code: "44444",
	category: "cat",
	name: "charity4",
	url: "http://www.google.com",
	mission_statement: "mission_statement"
	)
charity5 = Charity.create(
	ein: 5,
	city: "city",
	state: "state",
	zip_code: "55555",
	category: "cat",
	name: "charity5",
	url: "http://www.google.com",
	mission_statement: "mission_statement"
	)
charity6 = Charity.create(
	ein: 6,
	city: "city",
	state: "state",
	zip_code: "66666",
	category: "cat",
	name: "charity6",
	url: "http://www.google.com",
	mission_statement: "mission_statement"
	)

Donation.create(
	user_id: user1.id,
	charity_id: charity1.id
	)
Donation.create(
	user_id: user1.id,
	charity_id: charity2.id
	)
Donation.create(
	user_id: user1.id,
	charity_id: charity3.id
	)
Donation.create(
	user_id: user2.id,
	charity_id: charity4.id
	)
Donation.create(
	user_id: user2.id,
	charity_id: charity5.id
	)
Donation.create(
	user_id: user2.id,
	charity_id: charity6.id
	)
Donation.create(
	user_id: user3.id,
	charity_id: charity1.id
	)
Donation.create(
	user_id: user3.id,
	charity_id: charity3.id
	)
Donation.create(
	user_id: user3.id,
	charity_id: charity5.id
	)



