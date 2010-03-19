class FeedEntry < ActiveRecord::Base
  
  belongs_to :feed_site
  
  def self.default_per_box
    15
  end
  
  named_scope :per_box, :limit => default_per_box
  
end
