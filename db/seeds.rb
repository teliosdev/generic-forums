# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Group.create! [
  {:name => "guest" },
  {:name => "user"  },
  {:name => "admin" },
  {:name => "system"}
]
guest_pass = SecureRandom.hex(5)
User.create! :name => "guest", :password => guest_pass, :password_confirmation => guest_pass, :email => "guest@localhost.com", :avatar => "" do |u|
  u.id = 0
  u.group_ids = [1]
  #u.groups << Group.find(1)
end
User.create! :name => "admin", :password => "admin", :password_confirmation => "admin", :email => "admin@localhost.com", :avatar => "/admin.png" do |u|
  #u.groups << Group.find(1)
  #u.groups << Group.find(2)
  #u.groups << Group.find(3)
  u.group_ids = [1,2,3]
end
system_pass = SecureRandom.hex(5)
User.create! :name => "system", :password => system_pass, :password_confirmation => system_pass, :email => "system@localhost.com", :avatar => "/system.png" do |u|
  #u.groups << Group.find(1)
  #u.groups << Group.find(2)
  #u.groups << Group.find(3)
  #u.groups << Group.find(4)
  u.group_ids = [1,2,3,4]
end

Board.create! [
  {
    :name => "primary",
    :sub  => "first"
  },
  {
    :name => "secondary",
    :sub  => "second",
    :parent_id => 1
  }
]

b = Board.find(1)
b.ropes.create! :title => "ghost" do |r|
  r.is_ghost = true
  r.ghost_data = {}
  r.user_id = 2
end
b.ropes.create! :title => "Hello World" do |r|
  r.user_id = 1
end

b.ropes.create! :title => "Welcome" do |r|
  r.user_id = 1
end

b.ropes.find(2).posts.create! :body => "hello world", :format => "plain" do |r|
  r.user_id = 1
end

b.ropes.find(3).posts.create!(:format => "markdown", :body => <<-BODY
# Welcome to Generic Forums! #
We hope that your experience with these forums will be a pleasant one.  If you have any problems setting it up, you can just contact us at <redjazz96@gmail.com>.

Thanks for using Generic Forums!
BODY
) do |p|
  p.user_id = 1
end

b.permissions.create! :action => :read, :type => "Board", :group_id => 1
b.permissions.create! :action => :manage, :type => "Board", :group_id => 3
[:read, :post, :edit_own_post].each do |p|
    b.ropes.find(1).permissions.create! :action => p, :type => "Rope", :group_id => 2
end

b.ropes.find(1).permissions.create! :action => :read, :type => "Rope", :group_id => 1
b.ropes.find(1).permissions.create! :action => :manage, :type => "Rope", :group_id => 3
