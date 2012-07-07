# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Group.create! [
  {:name => "guest"},
  {:name => "user" },
  {:name => "admin"}
]
guest_pass = SecureRandom.hex(5)
User.create! :name => "guest", :password => guest_pass, :password_confirmation => guest_pass, :email => "guest@localhost.com", :avatar => "" do |u|
  u.id = 0
  u.groups << Group.find(1)
end
User.create! :name => "admin", :password => "admin", :password_confirmation => "admin", :email => "system@localhost.com", :avatar => "/admin.png" do |u|
  u.groups << Group.find(1)
  u.groups << Group.find(2)
  u.groups << Group.find(3)
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
b.ropes.create! :title => "Hello World", :user => User.find(1)
b.ropes.create! :title => "Welcome", :user => User.find(1)

b.ropes.find(1).posts.create! :user => User.find(1), :body => "hello world"
b.ropes.find(2).posts.create! :user => User.find(1), :body => <<-BODY
# Welcome to Generic Forums! #
We hope that your experience with these forums will be a pleasant one.  If you have any problems setting it up, you can just contact us at <redjazz96@gmail.com>.

Have a pleasant trip!
BODY
