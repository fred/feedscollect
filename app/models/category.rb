class Category < ActiveRecord::Base
  has_many :feed_sites, :order => "sort_order ASC, title DESC"
  after_save :clear_cache
  
  def self.default_category(home_page_category_id=nil)
    if home_page_category_id
      self.find(home_page_category_id)
    else
      self.first(:conditions => ["default_home = ?",true])
    end
  end
  
  
  def clear_cache
    ActionController::Base.new.expire_fragment("categories/#{self.id}")
    ActionController::Base.new.expire_fragment("categories/#{self.id}_mobile")
  end  

end
