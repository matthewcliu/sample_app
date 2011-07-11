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
  #Creates get and set methods that allow us to retrieve (get) and assign (set) password. That way you don't have to design separate actions.
  attr_accessor :password
  #Protects against mass assignments of variables, primarily from forms. Still allows controller and console changes.
  attr_accessible :name, :email, :password, :password_confirmation
  
  #Associations with many microposts
  has_many :microposts, :dependent => :destroy
  
  #Associations with relationships
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
                                                      
  #Associations with followings - followings should really be user.followeds, but it's been renamed as followings using the source :followed
  has_many :following, :through => :relationships, :source => :followed
  
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  
  
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  #Common regular expression for valid email addresses
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Simple validations for data
  validates :name, :presence => true,
                   :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence  => true,
                     # This is a trick that creates a virtual attribute 'password_confirmation' then prevents passwords that don't match from saving
                     :confirmation => true,
                     :length => { :within => 6..40 }
  
  #ActiveRecord will now call encrypt_password method before attempting to save to the db                   
  before_save :encrypt_password
  
  # Return true if user's stored password matches the submitted password. Should probably be named has_matching_password
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of submitted_password
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

#  def User.authenticate(email, submitted_password)
#    user = find_by_email(email)
#    return nil  if user.nil?
#    return user if user.has_password?(submitted_password)
#  end
  
  # Finds user by id then verifies salt is the correct one
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    #if-else combined into one line by ternary operator
    #Alternatively would be return nil if user.nil? return user is user.salt == cookie_salt
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  #Micropost status feed - ? escapes id
  def feed
    Micropost.from_users_followed_by(self)
  end
  
  #This section describes following methods
  
  #Boolean to see if followed is being followed
  def following?(followed)
    #Checks the relationship table to see if followed is found
    relationships.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    #Creates a new following relationship - self. creates a row with follower.id and adds followed.id in the second column
    self.relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed).destroy
  end
  
  private
  
    def encrypt_password
      #Creates a new salt record for the current object. new_record? returns true if the object has not yet been saved to the database.
      self.salt = make_salt if new_record?
      #self refers to the object itself so it encrypts the encrypted_password attribute within the current object
      self.encrypted_password = encrypt(self.password)
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
