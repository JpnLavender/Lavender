require 'twitter'
require 'curb'

host = ENV['HOST']

def slack_puts(text)
  Curl.post(
    ENV['WEBHOOKS'],
    { 
      channel: "#bot_tech",
      username: "Lavender ",
      text: text,
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
  case tweet
  when Twitter::Tweet
    puts tweet.full_text 
    Curl.post("#{host}stocking_tweet", { tweet_id: tweet.id, user_name: tweet.user.screen_name, text: tweet.full_text})
    if tweet.text =~ /テスト/
      client_rest.favorite(tweet.id)
      slack_puts(tweet.full_text)
    end
    if tweet.user.screen_name == "alpdaca"
      slack_puts("alpdaca -> #{tweet.full_text}")
    end
  when Twitter::Streaming::DeletedTweet
    data = JSON.parse(Curl.get("#{host}#{tweet.id}").body_str)
    if "#{tweet.id}" == data["tweet_id"]
      puts ("Delete: #{data["user_name"]}-> #{data["text"]}")
      slack_puts("Delete: #{data["user_name"]}-> #{data["text"]}")
    else 
      puts ("誰かがつい消ししたっぽい")
    end
  end
end
