require 'twitter'

class AyaminBot

  def initialize(config)
    @config = config
    @rest = Twitter::REST::Client.new(@config)
    @stream = Twitter::Streaming::Client.new(@config)
  end
  attr_reader :config, :rest, :stream

  def run
    streaming_run
  end
  
  def verification(data)
    data.user.screen_name == "ayamin_talk" && data.full_text =~ /彼/ ? true : false
  end

  def streaming_run
    @stream.user do |tweet|
      next unless tweet.is_a?(Twitter::Tweet)
      next unless verification(tweet)
      @rest.update("@#{object.user.screen_name} #{"かつみー" * 3}", options = {in_reply_to_status_id: object.id})
    end
  end


end

CONFIG = {
  consumer_key: ENV["SUB_CONSUMER_KEY"],
  consumer_secret: ENV["SUB_CONSUMER_SECRET"],
  access_token: ENV["SUB_ACCESS_TOKEN"],
  access_token_secret: ENV["SUB_ACCESS_TOKEN_SECRET"]
}

app = AyaminBot.new(CONFIG)
app.run
