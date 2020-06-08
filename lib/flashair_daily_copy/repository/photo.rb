require 'net/http'
require 'uri'

module FlashairDailyCopy
  module Repository
    class Photo < ::OpenStruct
      include FlashairDailyCopy::Logger

      # directory
      # file_name
      # size
      # attribute
      # datetime
      # url

      attr_reader :local_file

      def fetch
        uri = URI.parse(url)

        Net::HTTP.start(uri.host) do |http|
          info_log("  fetching: #{uri.path}")
          res = http.get(uri.path)

          @local_file = nil
          Tempfile.open(tmpdir: tmpdir) do |t|
            t.binmode
            t.write res.body
            @local_file = t
            yield(self)
          end
        end
      end

      def tmpdir
        ENV['TMP_DIR'] || Dir.tmpdir
      end
    end
  end
end
