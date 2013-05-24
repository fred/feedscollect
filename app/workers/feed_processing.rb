class FeedProcessing < BaseWorker

  def perform(start=nil)
    Sidekiq.logger.info("QUEUE: Start processing all feeds at: #{Time.now.to_s(:long)}")
    FeedSite.parallel_refresh
    Sidekiq.logger.info("QUEUE: Completed processing feeds at: #{Time.now.to_s(:long)}\n")
  end
end
