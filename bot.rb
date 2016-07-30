require 'twitter'
require 'curb'

host = ENV['HOST']

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
  slack_puts({
    attachments: [{
      author_icon: tweet.user.profile_image_url,
      author_name: tweet.user.name,
      author_subname: "@#{tweet.user.screen_name}",
      text: tweet.full_text,
      image_url: tweet.media,
      author_link: tweet.uri,
      color: "red",
    }]
  })
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
    Curl.post("#{host}/stocking_tweet", { tweet_id: tweet.id, user_name: tweet.user.name, text: tweet.full_text, url:tweet.uri, icon: tweet.user.profile_image_url})
    # case tweet.text 
    # when /テスト/
    #   client_rest.favorite(tweet.id)
    #   slack_puts("正常に動いてますよ^^")
    # when /社畜ちゃん/
    #   client_rest.favorite(tweet.id)
    #   slack_puts("#{tweet.user.name}が呼んでるよ")
    # end
    case tweet.user.screen_name 
    when "alpdaca"
      option(tweet)
    end
  when Twitter::Streaming::DeletedTweet
    data = JSON.parse(Curl.get("#{host}/Lavender/find_tweet/#{tweet.id}").body_str)
    if "#{tweet.id}" == data["tweet_id"]
      delete(data)
    else 
      puts ("誰かがつい消ししたっぽい")
    end
  end
end
