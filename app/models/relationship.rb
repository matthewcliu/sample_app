class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  #belongs to User model in two different ways since each relationship is between two users
  #Must supply the class name since there are no follower and followed models
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"
  
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true  

end
