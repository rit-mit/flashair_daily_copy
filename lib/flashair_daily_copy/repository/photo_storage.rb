module FlashairDailyCopy
  module Repository
    class PhotoStorage
      def initialize(io)
        @io = io
      end

      def files_in_dir(path, &block)
        @io.files_in_dir(path, &block)
      end
    end
  end
end
