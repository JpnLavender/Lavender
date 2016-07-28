require 'twitter'
require 'curb'

def slack_puts(tweet)
  Curl.post(
    ENV['WEBHOOKS'],
    { 
      channel: "#bot_tech",
      username: "Lavender ",
      text: tweet.full_text,
      icon_url: "http://19.xmbs.jp/img_fget.php/_bopic_/923/e05cec.png"
    }.to_json
  )
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
  Tweet.create(
    tweet_id: tweet.id, 
    user_name: tweet.user.screen_name,
    text: tweet.full_text,
    img_url: .media.first.expanded_url.to_s
  )
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
    if tweet = Tweet.find_by(tweet_id: tweet.id)
      slack_puts("Delete: #{tweet.name}-> #{tweet.text}")
    end
  end
end
