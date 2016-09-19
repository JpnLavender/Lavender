require 'twitter'

class BinjyouBot

  def initialize(config)
    @config = config
    @rest = Twitter::REST::Client.new(@config)
    @stream = Twitter::Streaming::Client.new(@config)
  end
  attr_reader :config, :rest, :stream

  def run
    streaming_run
  end

  def random 
    {text: ["たしかに","せやな","それな！","わかるわ！"].sample , kaomoji: ["(・∀・)","(^q^)","ლ(´ڡ`ლ)`)","( ˘ω˘)"].sample }
  end

  def verification(data)
    /^RT/ =~ data.full_text && tweet.user.screen_name =~ /sawawankagi|h_ayaha19|hananigashi19|sawasan0519/ ?  true : false
  end

  def streaming_run
    next unless tweet.is_a?(Twitter::Tweet)
    next unless verification(tweet)
    @rest.update("@#{tweet.user.screen_name} #{random[:text]}#{random[:kaomoji]}", options = {in_reply_to_status_id: tweet.id})
  end

end

CONFIG = {
  consumer_key: ENV["SUB_CONSUMER_KEY"],
  consumer_secret: ENV["SUB_CONSUMER_SECRET"],
  access_token: ENV["SUB_ACCESS_TOKEN"],
  access_token_secret: ENV["SUB_ACCESS_TOKEN_SECRET"]
}

app = BinjyouBot.new(CONFIG)
app.run
