require 'digest'

class User < ActiveRecord::Base
	attr_accessor :password #We will only store encrypted password; therefore this is virtual attribute, an attribute not corresponding to a colomn in database.
							#password attribute only exists in memory for confirmaton step and encryption step.
	
	attr_accessible :name, :email, :userType, :password, :password_confirmation

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, :presence => true,
					 :length => { :maximum => 50 }
					 
	validates :email, :presence => true,
					  :format => { :with => email_regex },
					  :uniqueness => { :case_sensitive => false }
	validates :userType, :presence => true
					  
	validates :password, :presence => true,
						 :confirmation => true,  #reject users whose password and confirmation doesn't match
						 :length => { :within => 6..40 }
						 
	 before_save :encrypt_password
	 
	 
	 # Return true if the user's password matches the submitted password.
	 def has_password?(submitted_password)
	 	encrypted_password == encrypt(submitted_password)
	 end
	 
	 def self.authenticate(email, submitted_password)
	 	user = find_by_email(email)
	 	return nil if user.nil?
	 	return user if user.has_password?(submitted_password)
	 end
	 
	 
	 
	 private
	 
	 def encrypt_password
	 	self.salt = make_salt if new_record?  #We don’t want user's salt attribute to change every time the user is updated. We ensure that the salt is only created once,
	 	self.encrypted_password = encrypt(password)
	 end
	 
	 def encrypt(string)
	 	secure_hash("#{salt}--#{string}")
	 end
	 
	 def make_salt 
	 	secure_hash("#{Time.now.utc}--#{password}")
	 end
	 
	 def secure_hash(string)
	 	Digest::SHA2.hexdigest(string)
	 end
end
