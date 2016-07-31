require 'twitter'
require 'curb'

$host = ENV['HOST']

def slack_puts(attachments)
  Curl.post(
    ENV['WEBHOOKS'],
    { 
      channel: "#bot_tech",
      username: "Lavender",
      icon_url: "http://19.xmbs.jp/img_fget.php/_bopic_/923/e05cec.png"
    }.merge(attachments).to_json
  )
  puts "#{Time.now} 受信"
end

def option(tweet)
    attachments = [{
      author_icon: tweet.user.profile_image_url,
      author_name: tweet.user.name,
      author_subname: "@#{tweet.user.screen_name}",
      text: tweet.full_text,
      author_link: tweet.uri,
      color: "red" }]
    tweet.media.map{ |img| attachments[0].merge!({image_url: img.media_uri})}
    slack_puts(attachments: attachments )
end

def delete(tweet)
  slack_puts({
    attachments: [{
      author_icon: tweet["icon"],
      author_name: tweet["user_name"],
      text: tweet["text"],
      # image_url: tweet.media,
      author_link: tweet["url"],
      color: "red",
    }]
  })
end

def database_post(tweet)
  media = []
  tweet.media.map{ |img| media << img.media_uri }
  Curl.post("#{$host}/stocking_tweet", { tweet_id: tweet.id, user_name: tweet.user.name, text: tweet.full_text, url:tweet.uri, icon: tweet.user.profile_image_url, media: media})
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
    puts "#{tweet.user.name} -> #{tweet.full_text}\n\n" 
    database_post(tweet)
    case tweet.user.screen_name 
    when "alpdaca" , "ni_sosann" , "usr_meloco" , "serin_inaka", "osrmishi"
      option(tweet)
    end
  when Twitter::Streaming::DeletedTweet
    data = JSON.parse(Curl.get("#{$host}/Lavender/find_tweet/#{tweet.id}").body_str)
    if "#{tweet.id}" == data["tweet_id"]
      delete(data)
    else 
      puts ("誰かがつい消ししたっぽい")
    end
  end
end
