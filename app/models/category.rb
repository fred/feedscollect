class Category < ActiveRecord::Base
  
  has_many :feed_sites, :order => "sort_order ASC, title DESC"
  
  def self.default_category
    self.first(:conditions => ["default_home = ?",true])
  end
  
end
