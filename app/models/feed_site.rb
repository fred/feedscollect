class FeedSite < ActiveRecord::Base
  
  attr_writer :skip_refresh
  
  has_attached_file :avatar, :styles => { :large => "200x30>", :medium => "180x28>", :small => "160x26>" }
  
  belongs_to :category
  has_many :feed_entries, :order => "published DESC, id DESC", :dependent => :destroy
  
  # Change to after_create later
  before_save :save_details
  
  FEED_TYPES = [ 
    {:id => 1, :name => "atom"}, 
    {:id => 2, :name => "atom_feedburner"},
    {:id => 3, :name => "rss"},
    {:id => 4, :name => "itunes_rss"}
  ]
  
  def skip_refresh
    @skip_refresh || nil
  end
  
  def category_name
    self.category.title if self.category
  end
  
  def force_refresh
    self.etag = nil
    self.last_modified  = nil
    self.feed_entries.destroy_all
    self.save
  end
  
  def self.refresh
    FeedSite.all.each do |t|
      logger.info "Refreshing feed: #{t.url}..."
      if t.save
        logger.info "...success for feed: #{t.url}"
      end
    end
  end
  
  def save_details
    feed = Feedzirra::Feed.fetch_and_parse(self.url.to_s)
    return unless feed
    self.title = feed.title.to_s if self.title.to_s.blank?
    self.description = feed.class.to_s if self.description.to_s.blank?
    self.site_url = feed.url.to_s
    if (feed.etag && (feed.etag.to_s != self.etag)) or (feed.last_modified.to_i > self.last_modified.to_i) 
      feed.entries.each do |t| 
        if t.last_modified.to_i > self.last_modified.to_i
          fi = FeedEntry.new
          fi.title = t.title
          fi.url = t.url
          fi.author = t.author
          fi.summary = t.summary
          #fi.content = t.content
          fi.published = t.published
          fi.save
          self.feed_entries << fi
        end
      end
      self.last_modified = feed.last_modified
      self.etag = feed.etag.to_s
    end
  end
  
end
