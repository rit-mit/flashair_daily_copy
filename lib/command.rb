require 'thor'
require_relative './flashair_daily_copy.rb'

####################
# signal trap
# https://tmtms.hatenablog.com/entry/2014/09/23/ruby-signal
mutex = Mutex.new
$sigint = false

Thread.new do
  loop do
    if $sigint
      $sigint = false
      mutex.synchronize do
        puts "\n"
        puts 'interrupted!'
        sleep 1
        exit 0
      end
    end
    sleep 0.1
  end
end

trap :INT do
  $sigint = true
end
trap :TERM do
  $sigint = true
end
####################

class Command < ::Thor
  desc 'start', 'execute download from flashair'
  method_option :hostname, aliases: '-h', contents: :string, banner: 'Flashair hostname'
  def start
    hostname = options[:hostname] || ENV['FLASH_AIR_HOSTNAME'] || 'myflashair.local'

    ::FlashairDailyCopy::Service.call(hostname: hostname)
  rescue StandardError => e
    puts 'Exception!'
    pp e.class
    pp e.message
    pp e.backtrace
    $sigint = true
  end
end
