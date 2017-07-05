require './models.rb'

class TweetDeleteChecker

  def initialize(config)
    @config = config
    @rest   = Twitter::REST::Client.new(@config)
    @stream = Twitter::Streaming::Client.new(@config)
  end
  attr_reader :config, :rest, :stream

  def slack_post(tweet)
    puts "RUN: SlackPost"
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
    conf = { 
      channel: ENV.fetch("SLACK_POST_CHANNEL"), 
      username: ENV.fetch("SLACK_USERNAME"), 
    }.merge({attachments: attachments})
    Curl.post( ENV.fetch('WEBHOOKS'), conf.to_json )
    puts JSON.pretty_generate(conf)
    puts "FINISH: SlackPost"
  end

  def database_post(tweet)
    puts "RUN: SaveTweet"
    Tweet.create( 
                 tweet_id:    tweet.id,
                 screen_name: tweet.user.screen_name,
                 user_name:   tweet.user.name,
                 text:        tweet.full_text,
                 img_url:        tweet.user.profile_image_url,
                 url:         tweet.uri, 
                 color:       tweet.user.profile_link_color
                )
    puts "FINISH: SaveTweet"
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
          profile_image_url:  tweet.img_url,
          profile_link_color: tweet.color
        }
      }
    else
      {error: "404"}
    end
  end

  def streaming_run
    puts "RUN: Striaming"
    @stream.user do |tweet|
      begin
        case tweet
        when Twitter::Tweet
          next if tweet.full_text =~ /^RT/ 
          database_post(tweet)
        when Twitter::Streaming::DeletedTweet
          data = Hashie::Mash.new(tweet_data(tweet.id))
          next unless "#{tweet.id}" == data.tweet_id
          data.full_text = "Delete\n" + "#{data.full_text}"
          slack_post(data)
        end
      rescue
        next
      end
    end
  end

end

CONFIG = {
  consumer_key:        ENV.fetch("CONSUMER_KEY"),
  consumer_secret:     ENV.fetch("CONSUMER_SECRET"),
  access_token:        ENV.fetch("ACCESS_TOKEN"),
  access_token_secret: ENV.fetch("ACCESS_TOKEN_SECRET")
}

app = TweetDeleteChecker.new(CONFIG)
app.streaming_run
