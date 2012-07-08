# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
	user.name 					"Example User"
	user.email 					"ex@example.com"
	user.userType				1
	user.password 				"foobar"
	user.password_confirmation  "foobar"
end	