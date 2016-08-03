require 'twitter'

puts "ついけし監視Bot起動！"

Tweet.config.user do |tweet|
  case tweet
  when Twitter::Tweet
    Tweet.database_post(tweet)
    case tweet.user.screen_name 
    when "alpdaca" , "ni_sosann" , "usr_meloco" , "osrmishi"
      Tweet.slack_post_options(tweet)
    end
    case tweet
    when /社畜ちゃん/
      Slappy.say "#{tweet.user.name}に呼ばれてるよ！\n #{tweet.uri}"
    end
  when Twitter::Streaming::DeletedTweet
    data = JSON.parse(Curl.get("#{$host}/Lavender/find_tweet/#{tweet.id}").body_str)
    if "#{tweet.id}" == data["tweet_id"]
      Tweet.deleted_tweet(data)
    else 
      # Slappy.say "誰かがつい消ししたっぽい"
    end
  end
end
