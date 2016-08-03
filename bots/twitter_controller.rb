require 'twitter'
require 'curb'
$host = ENV['HOST']

class Tweet
  def self.config
    @client = Twitter::Streaming::Client.new do |config|
      config.consumer_key    = ENV["CONSUMER_KEY"]
      config.consumer_secret = ENV["CONSUMER_SECRET"]
      config.access_token    = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end

  def self.slack_post(attachments)
    conf = { channel: "#bot_tech", username: "Lavender", icon_url: "http://19.xmbs.jp/img_fget.php/_bopic_/923/e05cec.png"}.merge(attachments)
    ENV["PRODUCTION"] ? nil : Curl.post( ENV['WEBHOOKS'],JSON.pretty_generate(conf))
    puts JSON.pretty_generate(conf)#テストコード追加
  end

  def self.slack_post_options(tweet)
    attachments = [{
      author_icon: tweet.user.profile_image_url.to_s,
      author_name: tweet.user.name,
      author_subname: "@#{tweet.user.screen_name}",
      text: tweet.full_text,
      author_link: tweet.uri.to_s,
      color: tweet.user.profile_link_color
    }] 
    tweet.media.each_with_index do |v,i|
      attachments[i] ||= {}
      attachments[i].merge!({image_url: v.media_uri })
    end
    slack_post({attachments: attachments})
  end

  def self.deleted_tweet(tweet)
    slack_post({ attachments: [{
      author_icon: tweet["icon"],
      author_name: tweet["user_name"],
      text: "Delete:\n #{tweet["text"]}",
      author_link: tweet["url"],
      color: "red",
    }]
    })
  end

  def self.database_post(tweet)
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
end
