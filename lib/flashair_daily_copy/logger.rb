require 'logger'

module FlashairDailyCopy
  module Logger
    def info_log(message)
      logger.info(message)
    end

    def warn_log(message)
      logger.warn(message)
    end

    def debug_log(message)
      logger.debug(message)
    end

    private

    def logger
      @logger ||= ::Logger.new(STDOUT).tap { |l| l.level = ::Logger::INFO }
    end
  end
end
