class FeedEntry < ActiveRecord::Base
  
  belongs_to :feed_site
  
  named_scope :per_box, :limit => 14

end
