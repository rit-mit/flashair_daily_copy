require 'thor'
require_relative './flashair_daily_copy.rb'

class Command < ::Thor
  desc 'start', 'execute download from flashair'
  method_option :hostname, aliases: '-h', contents: :string, banner: 'Flashair hostname'
  def start
    hostname = options[:hostname] || ENV['FLASH_AIR_HOSTNAME'] || 'myflashair.local'

    ::FlashairDailyCopy::Service.call(hostname: hostname)
  end
end
