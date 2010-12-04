class FeedSite < ActiveRecord::Base
  require 'timeout'
  
  attr_writer :skip_refresh
  
  has_attached_file :avatar, 
    :styles => { :large => "200x30>", :medium => "180x28>", :small => "160x26>" },
    :convert_options => { :thumb => '-quality 96' }
  
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
      puts ""
    end
    Category.all.each {|t| t.touch}
    GC.start
  end
  
  def save_details
    @entries_count = 0
    feed = nil
    feed = Feedzirra::Feed.fetch_and_parse(self.url.to_s)
    # sometimes we get 404 errors on feeds (Fixnum)
    if (feed.nil? or (feed.is_a? Fixnum) or feed.class.to_s.match("Feedzirra").nil?)
      msg=" *** Error: feed:#{feed}, class:#{feed.class}"
      puts msg
      logger.info msg
      return false
    end
    self.title = feed.title.to_s if self.title.to_s.blank?
    self.description = feed.class.to_s if self.description.to_s.blank?
    self.site_url = feed.url.to_s
    # Skip 5 minutes, might loose a few feeds.
    # will happen rarelly, but helps to avoid dupplicate entries 
    etag = nil
    etag = feed.etag if feed.etag
    msg = "Checking etag: #{etag}"
    logger.info msg 
    puts msg
    
    if feed.last_modified && (feed.last_modified.is_a? Time)
      feed_last_modified = feed.last_modified 
    elsif feed.last_modified && (feed.last_modified.is_a? String)
      feed_last_modified = Time.parse(feed.last_modified) 
    else
      feed_last_modified = nil
    end
    
    @feed_entries_count = self.feed_entries.count
    if (@feed_entries_count==0) or (etag && (etag != self.etag)) or (feed_last_modified.to_i > (self.last_modified.to_i+60))
      
      feed.entries.each do |t|  
        # Some stupid RSS feeds don't put last_modified on the feed entry.
        # if don't have last_modified, im skiping, screw those.
        if t.last_modified && (t.last_modified.is_a? Time)
          last_modified = t.last_modified 
        elsif t.last_modified && (t.last_modified.is_a? String)
          last_modified = Time.parse(t.last_modified) 
        else
          last_modified = nil
        end
        # allow 60 seconds delay for feed saving, to avoid dupplicates 
        # again, might loose a feed entry in rare cases.
        if (@feed_entries_count==0) or (last_modified && (last_modified.to_i > (self.last_modified.to_i+60)))
          fi = FeedEntry.new
          fi.title = t.title
          fi.url = t.url
          fi.url = fi.url unless (!t.url && fi.url && fi.url.match(/^http|^https/))
          fi.author = t.author
          fi.summary = t.summary 
          fi.content = t.content if (self.featured)
          fi.published = last_modified
          fi.save
          msg="new: #{fi.title}"
          logger.info msg
          puts msg
          self.feed_entries << fi
          @entries_count +=1
        end
      end
      msg = "Added #{@entries_count} new items to #{feed.title}."
      logger.info msg
      puts msg
      self.last_modified = feed_last_modified
      self.etag = etag
    end
    true
  end
  
end
