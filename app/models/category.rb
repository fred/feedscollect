class Category < ActiveRecord::Base
  has_many :feed_sites, :order => "sort_order ASC, title DESC"
  after_save :clear_cache
  
  def self.default_category
    self.first(:conditions => ["default_home = ?",true])
  end
  
  def clear_cache
    ActionController::Base.new.expire_fragment("categories/#{self.id}")
    ActionController::Base.new.expire_fragment("categories/#{self.id}_mobile")
  end  

end
