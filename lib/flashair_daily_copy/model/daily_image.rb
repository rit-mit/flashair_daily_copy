module FlashairDailyCopy
  module Model
    class DailyImage
      include FlashairDailyCopy::Logger

      attr_reader :photo

      def initialize(photo)
        @photo = photo
      end

      def self.save(photo)
        new(photo).save
      end

      def save
        info_log("#{photo.file_name} .....")
        info_log("  to: #{daily_folder_name}")

        photo.fetch do |fetched_photo|
          remote_file_name = fetched_photo.file_name
          next if daily_folder.exists? remote_file_name

          info_log("  uploading: #{remote_file_name}")
          daily_folder.upload(fetched_photo.local_file, remote_file_name)
        end

        info_log('..... finish')
      end

      private

      def daily_folder_name
        @daily_folder_name ||= DestinationPath.new(photo.file_name, photo.datetime).dir_name
      end

      def root_folder
        @root_folder ||= Repository::GoogleDrive::Folder.build_by_id(folder_id: ENV['GOOGLE_DRIVE_UPLOAD_FOLDER_ID'])
      end

      def daily_folder
        return @daily_folder unless @daily_folder.nil?

        @daily_folder = root_folder.find_folder_by_name(daily_folder_name)
        @daily_folder ||= root_folder.create_folder(daily_folder_name)
      end
    end
  end
end
