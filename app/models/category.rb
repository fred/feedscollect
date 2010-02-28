class Category < ActiveRecord::Base
  
  has_many :feed_sites, :order => "title ASC, id DESC"
  
end
