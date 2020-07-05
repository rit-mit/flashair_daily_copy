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
  method_option :folder_id, aliases: '-f', contents: :string, banner: 'GoogleDrive folder id'
  def start
    hostname = options[:hostname] || ENV['FLASH_AIR_HOSTNAME'] || 'myflashair.local'
    folder_id = options[:folder_id] || ENV['GOOGLE_DRIVE_UPLOAD_FOLDER_ID']

    ::FlashairDailyCopy::Service.call(hostname: hostname, folder_id: folder_id)
  rescue StandardError => e
    puts 'Exception!'
    pp e.class
    pp e.message
    pp e.backtrace
    $sigint = true
  end
end
