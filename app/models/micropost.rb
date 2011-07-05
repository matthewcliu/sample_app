class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  #Associations with a single user
  belongs_to :user
  
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  #Re-orders by reverse chronological order (DESC is descending in SQL)
  default_scope :order => 'microposts.created_at DESC'

end
