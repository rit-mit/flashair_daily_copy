require 'httpclient'
require 'csv'
require 'resolv'

require_relative './photo.rb'

module FlashairDailyCopy
  module Repository
    class Flashair
      include FlashairDailyCopy::Logger

      attr_reader :hostname

      def initialize(hostname)
        @hostname = hostname
      end

      def files(path)
        [].tap do |list|
          get_rows(url_for_files(path)) do |row|
            list << build_photo(row) if row.count == 6
          end
        end
      end

      def image_dirs(path)
        files(path)
          .reject { |file| file.file_name == '100__TSB' }
          .map { |file| "/DCIM/#{file.file_name}" }
      end

      def files_in_dir(path)
        image_dirs(path).each do |file_path|
          files(file_path).each do |photo|
            info_log("yield photo: #{photo.file_name} at #{photo.datetime}")
            yield(photo)
          end
        end
      end

      def hostname_is_available?
        Resolv.getaddress hostname
        true
      rescue Resolv::ResolvError
        false
      end

      def url_for_files(path)
        "http://#{hostname}/command.cgi?op=100&DIR=#{path}"
      end

      def get_rows(api_url)
        csv = HTTPClient.new.get_content(api_url)
        CSV.parse(csv).each do |row|
          yield(row)
        end
      end

      def build_photo(row)
        Photo.new(
          directory: row[0],
          file_name: row[1],
          size: row[2],
          attribute: convert_attribute(row[3]),
          datetime: convert_datetime(row[4], row[5]),
          url: "http://#{hostname}#{row[0]}/#{row[1]}"
        )
      end

      def convert_attribute(val)
        # TODO: 属性は必要無さそうなので実装を省略
        val
      end

      def convert_datetime(date_val, time_val)
        year, mon, day = parse_date(date_val)
        hour, min, sec = parse_time(time_val)

        DateTime.new(year, mon, day, hour, min, sec)
      end

      def parse_date(date_val)
        binary_num = format('%016d', date_val.to_i.to_s(2))
        year = binary_num.slice!(0, 7).to_i(2) + 1980
        mon  = binary_num.slice!(0, 4).to_i(2)
        day  = binary_num.to_i(2)
        [year, mon, day]
      end

      def parse_time(time_val)
        binary_num = format('%016d', time_val.to_i.to_s(2))
        hour = binary_num.slice!(0, 5).to_i(2)
        min  = binary_num.slice!(0, 6).to_i(2)
        sec  = binary_num.to_i(2)
        [hour, min, sec]
      end
    end
  end
end
