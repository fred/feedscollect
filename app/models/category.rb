class Category < ActiveRecord::Base
  has_many :feed_sites, order: "sort_order ASC, title DESC"
  has_and_belongs_to_many :users
  after_save :clear_cache
  
  belongs_to :owner, class_name: "User"

  def self.general
    where(owner_id: nil)
  end

  def self.general_and_own(user_id=nil)
    self.general + User.find(user_id).own_categories
  end

  def self.default_category(home_page_category_id=nil)
    if home_page_category_id
      self.find(home_page_category_id)
    else
      self.where("default_home = ?", true).first
    end
  end

  # Returns an improved cache_key that includes the last image on the item
  def cache_key_full
    if self.last_feed_site
      self.cache_key + "/" + self.last_feed_site.updated_at.to_s(:number)
    else
      self.cache_key
    end
  end

  def last_feed_site
    self.feed_sites.order("updated_at DESC").first
  end

  def clear_cache
    system("rm -rf #{Rails.root}/tmp/cache/*")
  end

end
