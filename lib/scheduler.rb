#### Run a scheduler on another celluloid Thread
# https://gist.github.com/e637d1194c45716797c5

require 'celluloid'

module Technews
  class FeedScheduler
    include Celluloid

    # run every 30 minutes
    POLL_INTERVAL = 1800

    def run
      Sidekiq.logger.info("[Celluloid] Starting Feed Processing scheduler thread")
      loop do
        sleep 10
        Sidekiq.logger.info("[Celluloid] Running Feed Processing from scheduler thread")
        ::FeedProcessing.perform_async
        sleep POLL_INTERVAL
      end
    rescue => ex
      return if ex.is_a?(Celluloid::Task::TerminatedError)
      Sidekiq.logger.error "[Celluloid] Feed Processing failed! -- "+ex.message+"\n"+ex.backtrace.join("\n")
    end
  end
end
