require 'resque-history'

class FeedProcessing
  extend Resque::Plugins::History
  @max_history = 50
  @queue = :feed_queue
  
  def self.perform
    msg = "*** Resque: Start processing all feeds at: #{Time.now.to_s(:long)}"
    Rails.logger.info(msg)
    puts msg
    
    FeedSite.refresh
    
    msg = "*** Resque: Completed processing feeds at: #{Time.now.to_s(:long)}"
    Rails.logger.info(msg)
    puts msg
  end
end
