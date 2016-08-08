puts "TweetCheckr"
require './models.rb'

puts "ユーザー監視 -> #{$user_streaming}"
favo_user = Tweet.list_join_members(762160635719225344)

Tweet.config.user do |tweet|
  case tweet
  when Twitter::Tweet
    Tweet.database_post(tweet)
    case tweet.full_text
    when /社畜ちゃん/
      Slappy.say "#{tweet.user.name}に呼ばれてるよ！\n #{tweet.uri}"
    end
    case tweet.user.screen_name
    when *favo_user
      puts $user_streaming
      $user_streaming ? Tweet.slack_post_options(tweet) : "この機能は現在停止中です"
    end
  end
end
