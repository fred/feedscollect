class FeedProcessing
  @queue = :feed_queue
  
  def self.perform
    Rails.logger.info("*** Resque: Refreshing all feeds now #{Time.now.to_s(:long)}")
    FeedSite.refresh
    Rails.logger.info("*** Resque: Completed processing feeds")
  end
end
