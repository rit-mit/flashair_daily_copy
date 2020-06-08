require 'google_drive'
require 'googleauth'
require 'googleauth/stores/file_token_store'

module FlashairDailyCopy
  module Repository
    module GoogleDrive
      class Client
        OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
        TOKEN_FILENAME = 'credentials.yaml'.freeze
        SCOPE = ::Google::Apis::DriveV3::AUTH_DRIVE
        USER_ID = 'default'.freeze

        def self.build
          credential = new.authorize
          ::GoogleDrive::Session.from_credentials(credential)
        end

        def authorize
          token_store = ::Google::Auth::Stores::FileTokenStore.new(file: token_file_path)
          authorizer = ::Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)

          credentials = authorizer.get_credentials(USER_ID)

          if credentials.nil?
            url = authorizer.get_authorization_url base_url: OOB_URI

            puts 'Open the following URL in the browser and enter the ' \
             "resulting code after authorization:\n" + url

            code = gets
            credentials = authorizer.get_and_store_credentials_from_code(
              user_id: USER_ID,
              code: code,
              base_url: OOB_URI
            )
          end
          credentials
        end

        private

        def client_id
          @client_id ||= ::Google::Auth::ClientId.from_file(credential_secret_file_path)
        end

        def credentials_dir
          return @credentials_dir unless @credentials_dir.nil?

          dir_name = ENV['CREDENTIAL_DIR'] || './credentials'
          @credentials_dir = ::Pathname.new(dir_name)
        end

        def credential_secret_file_path
          credential_secret_filename = ENV['CREDENTIAL_SECRET_FILENAME'] || 'client_secret.json'

          credentials_dir.join(credential_secret_filename).to_s
        end

        def token_file_path
          credentials_dir.join(TOKEN_FILENAME).to_s
        end
      end
    end
  end
end
