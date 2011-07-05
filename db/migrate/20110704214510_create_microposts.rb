class CreateMicroposts < ActiveRecord::Migration
  def self.up
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    #Add indices so it is easier to query by user and by reverse chronological order
    add_index :microposts, :user_id
    add_index :microposts, :created_at
  end

  def self.down
    drop_table :microposts
  end
end
