require 'twitter'

require './lib/twitter/twitter_client'

module Twitter
  class AdminTwitter < TwitterClient
    class << self
      def tweet(text)
        # 本番環境以外の時はツイートしない
        if Rails.env != 'production'
          @result = {
            status: "This environment is not production.",
            is_success: false
          }
          return @result
        end

        begin
          client.update(text)
          @result = {status: "Success!!", is_success: true}
        rescue => e
          @result = {status: "Error. massages is " + e, is_success: false}
        end
        return @result
      end
    end
  end
end
