require 'twitter'
class Halloween

  def initialize(config)
    @config = config
    @rest = Twitter::REST::Client.new(@config)
    @stream = Twitter::Streaming::Client.new(@config)
  end
  attr_reader :config, :rest, :stream

  def run
    trick_or_treat_streaming
  end

  def trick_or_treat_streaming
    topics = ["trick or treat", "トリック・オア・トリート", "Trick or Treat"]
    @stream.filter(:track =>  topics.join(",") ) do |tweet|
      next unless tweet.is_a?(Twitter::Tweet)
      next if tweet.retweet?
      @rest.update("@#{tweet.user.screen_name} \n trickで! \n ※このツイートはBotによるものです", options = {in_reply_to_status_id: tweet.id})
      puts "Done!"
    end
  end

end
CONFIG = {
  consumer_key: ENV["SUB_CONSUMER_KEY"],
  consumer_secret: ENV["SUB_CONSUMER_SECRET"],
  access_token: ENV["SUB_ACCESS_TOKEN"],
  access_token_secret: ENV["SUB_ACCESS_TOKEN_SECRET"]
}

app = Halloween.new(CONFIG)
app.run
