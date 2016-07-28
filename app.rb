require 'twitter'
require 'curb'

def slack_puts(tweet)
  Curl.post(ENV['WEBHOOKS'], { channel: "#bot_tech", username: tweet.user.name, text: tweet.full_text, icon_url: tweet.user.profile_image_uri }.to_json)
  puts "#{Time.now} 受信"
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

puts "起動！"

client.user do |tweet|
  case tweet
  when Twitter::Tweet
    if tweet.text =~ /テスト/
      client_rest.favorite(tweet.id)
      slack_puts(tweet)
    end
    if tweet.user.screen_name == "alpdaca"
      slack_puts(tweet)
    end
  when Twitter::Streaming::DeletedTweet
    slack_puts("text->#{tweet.id}")
  end
end
