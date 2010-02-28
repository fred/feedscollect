class Category < ActiveRecord::Base
  
  has_many :feed_sites, :order => "title ASC, id DESC"
  
  def self.default_category
    self.first(:conditions => ["default_home = ?",true])
  end
  
end
