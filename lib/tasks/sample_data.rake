namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Example User",
               :email => "example@railstutorial.org",
               :password => "foobar",
               :password_confirmation => "foobar")
  #We have to toggle instead of simply setting to true because :admin is not under attr_accessible in the user model (security reasons)
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  #Generates 50 fake posts for the first 6 users
  User.all(:limit => 6).each do |user|
    50.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end

def make_relationships
  #Gets user to follow 50 other users and gets 38 other users to follow user
  users = User.all
  user = users.first
  #Create arrays of users to be followed and followers
  following = users[1..50]
  followers = users[3..40]
  #For each array, complete the following action
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
  
end