class Category < ActiveRecord::Base
  has_many :feed_sites, :order => "sort_order ASC, title DESC"
  has_and_belongs_to_many :users
  after_save :clear_cache
  
  belongs_to :owner, :class_name => "User"
  
  named_scope :general, :conditions => {:owner_id => nil}
  
  def self.general_and_own(user_id=nil)
    self.general + User.find(user_id).categories
  end
  
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
