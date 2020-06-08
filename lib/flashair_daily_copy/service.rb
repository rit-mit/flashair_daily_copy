module FlashairDailyCopy
  class Service
    IMAGE_DIR_PATH = '/DCIM'.freeze

    def initialize(hostname)
      @hostname = hostname
    end

    def self.call(hostname:)
      new(hostname).call
    end

    def call
      photo_storage.files_in_dir(dir_path) do |photo|
        Model::DailyImage.save(photo)
      end
    end

    private

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
