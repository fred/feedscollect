class FeedEntry < ActiveRecord::Base
  
  belongs_to :feed_site
  
  def self.default_per_box
    max  = 50
    show = 15
    if User.current_user
      show = User.current_user.feeds_per_page
    end
    if show > max
      show = max 
    end
    show
  end
  
  named_scope :per_box, :limit => default_per_box
  
  
end
