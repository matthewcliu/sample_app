# == Schema Information
# Schema version: 20110618224048
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

#Ruby library that allows for SHA2 hashes
require 'digest'

class User < ActiveRecord::Base
  #Creates get and set methods that allow us to retrieve (get) and assign (set) password
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  #Common regular expression for valid email addresses
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Simple validations for data
  validates :name, :presence => true,
                   :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence  => true,
                     # This is a trick that creates a virtaul attribute 'password_confirmation' then prevents passwords that don't match from saving
                     :confirmation => true,
                     :length => { :within => 6..40 }
  
  #ActiveRecord will now call encrypt_password method before attempting to save to the db                   
  before_save :encrypt_password
  
  # Return true if user's stored password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of submitted_password
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  # Finds user by id then verifies salt is the correct one
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    #if-else combined into one line by ternary operator
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private
  
    def encrypt_password
      #Creates a new salt record for the current object. new_record? returns true if the object has not yet been saved to the database.
      self.salt = make_salt if new_record?
      #self refers to the object itself so it encrypts the encrypted_password attribute within the current object
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt (string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      #Secure hash of nterpolation of time and password
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
end
