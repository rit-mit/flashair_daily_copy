module FlashairDailyCopy
  module Repository
    module GoogleDrive
      class Folder
        include FlashairDailyCopy::Logger

        def initialize(client:, folder:)
          @client = client
          @folder = folder
        end

        def self.build_by_id(folder_id:)
          client = Client.build

          folder = client.folder_by_id(folder_id)
          new(client: client, folder: folder)
        end

        def upload(local_file, remote_file_name)
          @folder.upload_from_file(local_file, remote_file_name, convert: false)
        end

        def create_folder(folder_name)
          folder = @folder.create_subfolder(folder_name)

          ::FlashairDailyCopy::Repository::GoogleDrive::Folder.new(client: @client, folder: folder)
        end
        alias create_subfolder create_folder

        def find_by_name(file_name)
          q = 'trashed = false'
          @folder.files(q: q).find { |f| f.title == file_name }
        end

        def find_folder_by_name(folder_name)
          q = "trashed = false and mimeType = 'application/vnd.google-apps.folder'"
          folder = @folder.files(q: q).find { |f| f.title == folder_name }
          return if folder.nil?

          ::FlashairDailyCopy::Repository::GoogleDrive::Folder.new(client: @client, folder: folder)
        end

        def exists?(file_name)
          f = find_by_name(file_name)
          result = !f.nil?
          info_log("  #{file_name} is exists!") if result

          result
        end
      end
    end
  end
end
