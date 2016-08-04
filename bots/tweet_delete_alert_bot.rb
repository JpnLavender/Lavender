require 'twitter'
require './models.rb'

puts "ついけし監視Bot起動！"

Tweeted.config.user do |tweet|
  case tweet
  when Twitter::Tweet
    Tweeted.database_post(tweet)
    case tweet.user.screen_name 
    when "alpdaca" , "ni_sosann" , "usr_meloco" , "osrmishi"
      $streaming ? Tweeted.slack_post_options(tweet) : "この機能は現在停止中です" 
    end
  when Twitter::Streaming::DeletedTweet
    data = JSON.parse(Curl.get("#{$host}/Lavender/find_tweet/#{tweet.id}").body_str)
    if "#{tweet.id}" == data["tweet_id"]
      $deleted_streaming ? Tweeted.slack_post_options(data) : "この機能は現在停止中です" 
    else 
      # Slappy.say "誰かがつい消ししたっぽい"
    end
  end
end
