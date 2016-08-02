require 'twitter'
require 'curb'
$host = ENV['HOST']

def slack_post(attachments)
  conf = { channel: "#bot_tech", username: "Lavender", icon_url: "http://19.xmbs.jp/img_fget.php/_bopic_/923/e05cec.png"}.merge(attachments)
  Curl.post( ENV['WEBHOOKS'],JSON.pretty_generate(conf))
  puts JSON.pretty_generate(conf)#テストコード追加
end

def slack_post_options(tweet)
  attachments = [{
    author_icon: tweet.user.profile_image_url.to_s,
    author_name: tweet.user.name,
    author_subname: "@#{tweet.user.screen_name}",
    text: tweet.full_text,
    author_link: tweet.uri.to_s,
    color: tweet.user.profile_link_color
    actions: [ 
      { name: "favo", text: "Favo", type: "button", value: "favo" },
      { name: "rt", text: "RT", type: "button", value: "rt" } 
    ] 
  }] 
  tweet.media.each_with_index do |v,i|
    attachments[i] ||= {}
    attachments[i].merge!({image_url: v.media_uri })
  end
  slack_post({attachments: attachments})
end

def deleted_tweet(tweet)
  slack_post({ attachments: [{
      author_icon: tweet["icon"],
      author_name: tweet["user_name"],
      text: "Delete:\n #{tweet["text"]}",
      author_link: tweet["url"],
      color: "red",
    }]
  })
end

def database_post(tweet)
  Curl.post(
    "#{$host}/stocking_tweet", 
    ({ 
      tweet_id: tweet.id,
      user_name: tweet.user.name,
      text: tweet.full_text,
      url:tweet.uri, 
      icon: tweet.user.profile_image_url,
    }).to_json)
end

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key    = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.access_token    = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end

puts "起動！"

client.user do |tweet|
  case tweet
  when Twitter::Tweet
    puts "#{tweet.user.name} -> #{tweet.full_text}\n\n" #テストコード
    database_post(tweet)
    case tweet.user.screen_name 
    when "alpdaca" , "ni_sosann" , "usr_meloco" , "osrmishi"
      slack_post_options(tweet)
    end
  when Twitter::Streaming::DeletedTweet
    data = JSON.parse(Curl.get("#{$host}/Lavender/find_tweet/#{tweet.id}").body_str)
    if "#{tweet.id}" == data["tweet_id"]
      puts data#テストコード
      deleted_tweet(data)
    else 
      puts ("誰かがつい消ししたっぽい")
    end
  end
end
