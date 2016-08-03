require 'twitter'
require './models.rb'
puts "起動！"
p Tweet.config
Tweet.config.user do |tweet|
  case tweet
  when Tweet::Tweet
    puts "#{tweet.user.name} -> #{tweet.full_text}\n\n" #テストコード
    Tweet.database_post(tweet)
    case tweet.user.screen_name 
    when "alpdaca" , "ni_sosann" , "usr_meloco" , "osrmishi"
      Tweet.slack_post_options(tweet)
    end
  when Tweet::Streaming::DeletedTweet
    data = JSON.parse(Curl.get("#{$host}/Lavender/find_tweet/#{tweet.id}").body_str)
    if "#{tweet.id}" == data["tweet_id"]
      Tweet.deleted_tweet(data)
    else 
      Slappy.say "誰かがつい消ししたっぽい"
    end
  end
end
