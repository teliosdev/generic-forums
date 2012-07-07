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

User.create! :name => "guest", :email => "guest@localhost.local", :password => SecureRandom.hex(5), :avatar => "" do |u|
  u.id = 0
  u.groups << Group.find(1)
end
User.create! :name => "admin", :email => "system@localhost.local", :password => "admin", :avatar => "/admin.png" do |u|
  u.groups << Group.find(1)
  u.groups << Group.find(2)
  u.groups << Group.find(3)
end
