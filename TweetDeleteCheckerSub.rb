require 'twitter'
require 'curb'
require 'hashie'
require "active_record"
require './models.rb'

class TweetDeleteChecker

  def initialize(config)
    @config = config
    @rest   = Twitter::REST::Client.new(@config)
    @stream = Twitter::Streaming::Client.new(@config)
    @favo_user = nil
  end
  attr_reader :config, :rest, :stream

  def run
    streaming_run
  end

  def slack_post(tweet)
    attachments = [{
      author_icon:    tweet.user.profile_image_url.to_s,
      author_name:    tweet.user.name,
      author_subname: "@#{tweet.user.screen_name}",
      text:           tweet.full_text,
      author_link:    tweet.uri.to_s,
      color:          tweet.user.profile_link_color
    }] 
    if tweet.media
      tweet.media.each_with_index do |v, i|
        attachments[i] ||= {}
        attachments[i].merge!({image_url: v.media_uri })
      end
    end
    conf = { channel: "#bot_tech", username: "Lavender", icon_url: "http://19.xmbs.jp/img_fget.php/_bopic_/923/e05cec.png"}.merge({attachments: attachments})
    Curl.post( ENV['WEBHOOKS'], conf.to_json )
    puts JSON.pretty_generate(conf)
  end

  def database_post(tweet)
    Tweet.create( 
                 tweet_id:    tweet.id,
                 screen_name: tweet.user.screen_name,
                 user_name:   tweet.user.name,
                 text:        tweet.full_text,
                 icon:        tweet.user.profile_image_url,
                 url:         tweet.uri, 
                 color:       tweet.user.profile_link_color
                )
  end

  def tweet_data(id)
    if tweet = Tweet.find_by(tweet_id: id)
      {
        tweet_id:             tweet.tweet_id,
        full_text:            tweet.text,
        uri:                  tweet.url,
        media:                nil,
        user: {
          name:               tweet.screen_name,
          screen_name:        tweet.user_name,
          profile_image_url:  tweet.icon,
          profile_link_color: tweet.color
        }
      }
    else
      {error: "404"}
    end
  end

  def streaming_run
    @stream.user do |tweet|
      if tweet.is_a?(Twitter::Tweet)
        database_post(tweet)
        next if tweet.full_text =~ /^RT/ 
        slack_post(tweet)
      elsif tweet.is_a?(Twitter::Streaming::DeletedTweet)
        data = Hashie::Mash.new(tweet_data(tweet.id))
        next unless "#{tweet.id}" == data.tweet_id
        data.full_text = "Delete\n" + "#{data.full_text}"
        slack_post(data)
      end
    end
  end

end

CONFIG = {
  consumer_key:        ENV["MAIN_CONSUMER_KEY"],
  consumer_secret:     ENV["MAIN_CONSUMER_SECRET"],
  access_token:        ENV["MAIN_ACCESS_TOKEN"],
  access_token_secret: ENV["MAIN_ACCESS_TOKEN_SECRET"]
}

app = TweetDeleteChecker.new(CONFIG)
app.run
