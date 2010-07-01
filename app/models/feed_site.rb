class FeedSite < ActiveRecord::Base
  require 'timeout'
  
  attr_writer :skip_refresh
  
  has_attached_file :avatar, :styles => { :large => "200x30>", :medium => "180x28>", :small => "160x26>" }
  
  belongs_to :category
  belongs_to :user
  
  has_many :feed_entries, :order => "published DESC, id DESC", :dependent => :destroy
  
  # Change to after_create later
  before_save :save_details
  
  after_save :clean_older_feeds
  
  FEED_TYPES = [ 
    {:id => 1, :name => "atom"}, 
    {:id => 2, :name => "atom_feedburner"},
    {:id => 3, :name => "rss"},
    {:id => 4, :name => "itunes_rss"}
  ]
  
  # Clear older feed_entries leaving only the 100 newest
  def clean_older_feeds
    total = self.feed_entries.count
    if (total>200)
      total = (total-200) 
      sql = "delete from feed_entries where feed_site_id = #{self.id} order by id ASC limit #{total}"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
  
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
  
  def self.refresh(start=1)
    all_feeds = FeedSite.find(:all, :conditions => ["id >= ?", start])
    all_feeds.each do |t|
      msg = "Refreshing feed: #{t.id}..."
      logger.info msg
      puts msg
      
      # 1 minute timeout
      begin
        Timeout::timeout(60) {
          if t.save
            msg = "...success for feed: #{t.id}"
          else
            msg = "...cannot save feed: #{t.id}"
          end          
        }
      rescue Timeout::Error
        msg = "...timeout for feed #{t.id}"
      end
      
      logger.info msg
      puts msg
    end
    Category.all.each {|t| t.touch}
    GC.start
  end
  
  def save_details
    feed = nil
    feed = Feedzirra::Feed.fetch_and_parse(self.url.to_s)
    # sometimes we get 404 errors on feeds (Fixnum)
    if (feed.nil? or (feed.is_a? Fixnum) or feed.class.to_s.match("Feedzirra").nil?)
      msg=" *** Error: #{feed}"
      puts msg
      logger.info msg
      return false
    end
    self.title = feed.title.to_s if self.title.to_s.blank?
    self.description = feed.class.to_s if self.description.to_s.blank?
    self.site_url = feed.url.to_s
    # Skip 5 minutes, might loose a few feeds, 
    # will happen rarelly, but helps to avoid dupplicate entries 
    if (feed.etag && (feed.etag.to_s != self.etag)) or (feed.last_modified.to_i > (self.last_modified.to_i+300))
      feed.entries.each do |t|
        # allow 10 seconds delay for feed saving, to avoid dupplicates 
        # again, might loose a feed in rare cases,
        if t.last_modified.to_i > (self.last_modified.to_i+10)
          fi = FeedEntry.new
          fi.title = t.title
          fi.url = t.url
          fi.author = t.author
          fi.summary = t.summary if self.user_id
          fi.content = t.content if self.user_id
          fi.published = t.published
          fi.url = feed.url.to_s+fi.url.to_s unless fi.url.match(/^http:|^https:/)
          fi.save
          self.feed_entries << fi
        end
      end
      self.last_modified = feed.last_modified
      self.etag = feed.etag.to_s
    end
  end
  
end
