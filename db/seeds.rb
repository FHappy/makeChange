# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# 

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
	ein: "1",
	city: "city",
	state: "state",
	zipCode: "11111",
	category: "cat",
	charityName: "charity1",
	url: "http://www.google.com",
	missionStatement: "missionStatement",
	website: "http://www.google.com/news"
	)
charity2 = Charity.create(
	ein: "2",
	city: "city",
	state: "state",
	zipCode: "22222",
	category: "cat",
	charityName: "charity2",
	url: "http://www.google.com",
	missionStatement: "missionStatement",
	website: "http://www.google.com/news"
	)
charity3 = Charity.create(
	ein: "3",
	city: "city",
	state: "state",
	zipCode: "33333",
	category: "cat",
	charityName: "charity3",
	url: "http://www.google.com",
	missionStatement: "missionStatement",
	website: "http://www.google.com/news"
	)
charity4 = Charity.create(
	ein: "4",
	city: "city",
	state: "state",
	zipCode: "44444",
	category: "cat",
	charityName: "charity4",
	url: "http://www.google.com",
	missionStatement: "missionStatement",
	website: "http://www.google.com/news"
	)
charity5 = Charity.create(
	ein: "5",
	city: "city",
	state: "state",
	zipCode: "55555",
	category: "cat",
	charityName: "charity5",
	url: "http://www.google.com",
	missionStatement: "missionStatement",
	website: "http://www.google.com/news"
	)
charity6 = Charity.create(
	ein: "6",
	city: "city",
	state: "state",
	zipCode: "66666",
	category: "cat",
	charityName: "charity6",
	url: "http://www.google.com",
	missionStatement: "missionStatement",
	website: "http://www.google.com/news"
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



