module FlashairDailyCopy
  module Model
    class DestinationPath
      attr_reader :local_file_name

      def initialize(local_file_name, datetime)
        @local_file_name = File.basename(local_file_name)
        @datetime = datetime
      end

      def file_path
        "#{dir_name}/#{@local_file_name}"
      end

      def self.file_path(local_file_name, datetime)
        new(local_file_name, datetime).file_path
      end

      def dir_name
        @datetime.strftime('%Y-%m-%d')
      end
    end
  end
end
