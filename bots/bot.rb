require './models.rb'
puts "起動！"
Tweet.config.user do |tweet|
  case tweet
  when Twitter::Tweet
    puts "#{tweet.user.name} -> #{tweet.full_text}\n\n" #テストコード
    Twitter.database_post(tweet)
    case tweet.user.screen_name 
    when "alpdaca" , "ni_sosann" , "usr_meloco" , "osrmishi"
      Twitter.slack_post_options(tweet)
    end
  when Twitter::Streaming::DeletedTweet
    data = JSON.parse(Curl.get("#{$host}/Lavender/find_tweet/#{tweet.id}").body_str)
    if "#{tweet.id}" == data["tweet_id"]
      Twitter.deleted_tweet(data)
    else 
      Slappy.say "誰かがつい消ししたっぽい"
    end
  end
end
