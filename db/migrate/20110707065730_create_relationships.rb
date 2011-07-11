class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    #Adds an index for the relationships table for the key :follower_id
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    #Composite index that enforces uniqueness of pairs of (follower_id, followed_id) - user can't follow the same user more than once
    add_index :relationships, [:follower_id, :followed_id], :unique => true
  end

  def self.down
    drop_table :relationships
  end
end
