class FeedSite < ActiveRecord::Base
  
  belongs_to :category
  has_many :feed_entries, :order => "published DESC, id DESC", :dependent => :destroy
  
  # Change to after_create later
  before_save   :save_details
  
  FEED_TYPES = [ 
    {:id => 1, :name => "atom"}, 
    {:id => 2, :name => "atom_feedburner"},
    {:id => 3, :name => "rss"},
    {:id => 4, :name => "itunes_rss"}
  ]
  
  def category_name
    self.category.title if self.category
  end
  
  def should_update
  end
  
  def save_details
    feed = Feedzirra::Feed.fetch_and_parse(self.url.to_s)
    return unless feed
    self.title = feed.title.to_s if self.title.to_s.blank?
    self.description = feed.class.to_s if self.description.to_s.blank?
    if (feed.etag && (feed.etag.to_s != self.etag)) or (feed.last_modified.to_i > self.last_modified.to_i) 
      feed.entries.each do |t| 
        if t.last_modified.to_i > self.last_modified.to_i
          fi = FeedEntry.new
          fi.title = t.title
          fi.url = t.url
          fi.author = t.author
          fi.summary = t.summary
          fi.content = t.content
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
