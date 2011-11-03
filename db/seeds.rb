# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

user = User.new(:email => "fred.the.master@gmail.com",
  :password => "welcome", 
  :password_confirmation => "welcome" 
)
user.save if user.valid?

role = Role.new(:name => "admin")
role.save if role.valid?

if user
  user.roles << role
end

Category.create(:title =>"Android", :description => "Android News", :default_home => false, :owner_id => user.id)
Category.create(:title =>"Apple & iPhone", :description => "Apple & iPhone News", :default_home => false, :owner_id => user.id)
Category.create(:title =>"Linux & Open Source", :description => "Linux & Open Source News", :default_home => false, :owner_id => user.id)
Category.create(:title =>"Ruby", :description => "Ruby & Ruby on Rails News", :default_home => false, :owner_id => user.id)
Category.create(:title =>"Tech & Gadgets", :description => "Technology & Gadgets News", :default_home => true, :owner_id => user.id)