require 'twitter'
require 'curb'
require 'hashie'
$host = ENV['HOST']
$streaming = true
$deleted_streaming = true

puts "TwitterController"

class Tweeted
  def self.config
    @client = Twitter::Streaming::Client.new do |config|
      config.consumer_key    = ENV["CONSUMER_KEY"]
      config.consumer_secret = ENV["CONSUMER_SECRET"]
      config.access_token    = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end

  def self.slack_post(attachments)
    unless ENV["PRODUCTION"] 
      nil 
    else
      conf = { channel: "#bot_tech", username: "Lavender", icon_url: "http://19.xmbs.jp/img_fget.php/_bopic_/923/e05cec.png"}.merge(attachments)
      Curl.post( ENV['WEBHOOKS'],JSON.pretty_generate(conf))
      puts JSON.pretty_generate(conf)
    end
  end

  def self.slack_post_options(tweet)
    tweet.class == Twitter::Tweet ? nil : tweet = (Hashie::Mash.new tweet)
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
    Tweeted.slack_post({attachments: attachments})
  end

  def self.database_post(tweet)
    Curl.post(
      "#{$host}/stocking_tweet", 
      ({ 
        tweet_id: tweet.id,
        name: tweet.user.screen_name,
        user_name: tweet.user.name,
        text: tweet.full_text,
        icon: tweet.user.profile_image_url,
        url:tweet.uri, 
        color: tweet.user.profile_link_color
      }).to_json)
  end

  def self.stop(bot_name)
    case bot_name
    when "StreamingStop"
      $streaming = false
      p "ユーザー監視を停止しました"
    when "DeleteBotStop"
      $deleted_streaming = false
      p "ついけし監視を停止しました"
    end
  end

end
