require 'twitter'

@slack_config = { username: "Lavender", channel: "#twitter_bot" , icon: "http://i.imgur.com/Jjwsc.jpg" }

def send(text)
  Curl.post(ENV['WEBHOOKS'], {channel: @slack_config[:channel], username: @slack_config[:username], text: text, icon_url: @slack_config[:icon]}.to_json)
end

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key    = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.access_token    = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end

client_rest = Twitter::REST::Client.new do |config|
  config.consumer_key    = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.access_token    = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end

client.user do |object|
  if object.is_a?(Twitter::Tweet)
    if object.text =~ /テスト/
      client_rest.favorite(object.id)
      send("[OK] Now Running Bot... ")
    end
    if object.user.screen_name == "alpdaca"
      send("@irimamekun  あるぱか→#{object.text}")
    end
  end
end
