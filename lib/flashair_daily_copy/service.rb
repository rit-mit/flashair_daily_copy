module FlashairDailyCopy
  class Service
    IMAGE_DIR_PATH = '/DCIM'.freeze
    QUEUE_SIZE = 3
    STOP = 0x01

    def initialize(hostname, folder_id = nil)
      @hostname = hostname
      @folder_id = folder_id
    end

    def self.call(hostname:, folder_id: nil)
      new(hostname, folder_id).call
    end

    def call
      @queue = ::Queue.new

      photo_storage.files_in_dir(dir_path) do |photo|
        @queue.push(photo)
      end
      @queue.push(STOP)

      enqueue
    end

    private

    def enqueue
      workers = (1..QUEUE_SIZE).map do
        Thread.start do
          loop do
            photo = @queue.pop

            if photo == STOP
              @queue.push(STOP)
              break
            end

            Model::DailyImage.save(folder: folder, photo: photo)
          end
        end
      end

      workers.map(&:join)
    end

    def folder
      @folder ||= Repository::GoogleDrive::Folder.build_by_id(folder_id: folder_id)
    end

    def folder_id
      @folder_id || ENV['GOOGLE_DRIVE_UPLOAD_FOLDER_ID']
    end

    def photo_storage
      Repository::PhotoStorage.new(flashair)
    end

    def flashair
      Repository::Flashair.new(@hostname)
    end

    def dir_path
      @dir_path ||= ENV['IMAGE_DIR_PATH'] || IMAGE_DIR_PATH
    end
  end
end
