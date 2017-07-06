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
    attachments = [{ #受け取ったデータをSlack用に装飾
      author_icon:    tweet.user.profile_image_url.to_s,
      author_name:    tweet.user.name,
      author_subname: "@#{tweet.user.screen_name}",
      text:           tweet.full_text,
      author_link:    tweet.uri.to_s,
      color:          tweet.user.profile_link_color
    }] 
    end
    data = { #装飾したDataと基本データをマージ
      channel: ENV.fetch("SLACK_POST_CHANNEL"), 
      username: ENV.fetch("SLACK_USERNAME"), 
    }.merge({attachments: attachments})
    Curl.post( ENV.fetch('WEBHOOKS'), data.to_json )
    puts JSON.pretty_generate(conf) #Dataの標準出力
    puts "FINISH: SlackPost"
  end

  def save_tweet(tweet)
    puts "RUN: SaveTweet"
    Tweet.create(  #TLから受け取ったデータの保存
                 tweet_id:    tweet.id,
                 screen_name: tweet.user.screen_name,
                 user_name:   tweet.user.name,
                 text:        tweet.full_text,
                 img_url:     tweet.user.profile_image_url,
                 url:         tweet.uri, 
                 color:       tweet.user.profile_link_color
                )
    puts "FINISH: SaveTweet"
  end

  def parse_data(tweet)
    # DBに保存されているデータを取り出し元の形式にParseする
    if tweet
      {
        tweet_id:             tweet.tweet_id,
        full_text:            tweet.text,
        uri:                  tweet.url,
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
          next if tweet.full_text =~ /^RT/ #内容がRTじゃなければ次へ
          save_tweet(tweet) #Tweetを保存
        when Twitter::Streaming::DeletedTweet #ツイ消しを感知した場合
          find_data = Tweet.find_by(tweet_id: tweet.id) #つい消しされたDataを探す
          data = Hashie::Mash.new(parse_data(find_data)) #つい消しされたデータをパース
          data.full_text = "Delete\n" + "#{data.full_text}" #ツイ消しだとわかるようにSlackに投げるデータに'Dalete'の文字列を
          slack_post(data) #取ってきたDataをSlackへPost
        end
      rescue
        next
      end
    end
  end

end

CONFIG = { #TwitterTokenKey
  consumer_key:        ENV.fetch("CONSUMER_KEY"),
  consumer_secret:     ENV.fetch("CONSUMER_SECRET"),
  access_token:        ENV.fetch("ACCESS_TOKEN"),
  access_token_secret: ENV.fetch("ACCESS_TOKEN_SECRET")
}

app = TweetDeleteChecker.new(CONFIG)
app.streaming_run
