require 'twitter'

class AutoReplyBot

  def initialize(config)
    @config = config
    @reply_text = gets
    @stream = Twitter::Streaming::Client.new(@config)
    @rest   = Twitter::REST::Client.new(@config)
  end

  attr_reader :config, :stream, :rest

  def run
    streaming_run
  end

  def verification(data)
    /RT/  =~  tweet.full_text && tweet.user.screen_name =~ /sawawankagi|h_ayaha19|hananigashi19|sawasan0519/ ? true : false
  end

  def streaming_run
    @stream.user do |tweet|
      next unless tweet.is_a?(Twitter::Tweet)
      next unless verification(tweet)
      @rest.update("@#{tweet.user.screen_name} #{message}", options = {in_reply_to_status_id: tweet.id})
    end
  end

end

CONFIG = {
  consumer_key: ENV["SUB_CONSUMER_KEY"],
  consumer_secret: ENV["SUB_CONSUMER_SECRET"],
  access_token: ENV["SUB_ACCESS_TOKEN"],
  access_token_secret: ENV["SUB_ACCESS_TOKEN_SECRET"]
}

app = AutoReplyBot(CONFIG)
app.run
