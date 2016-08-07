puts "TweetCheckr"
require './models.rb'

puts "ユーザー監視 -> #{$streaming}"

Tweet.config.user do |tweet|
  case tweet
  when Twitter::Tweet 
    case tweet.full_text 
    when /社畜ちゃん/
      Slappy.say "#{tweet.user.name}に呼ばれてるよ！\n #{tweet.uri}"
    end
    case tweet.user.screen_name 
    when "alpdaca" , "ni_sosann" , "usr_meloco" , "osrmishi"
      puts $streaming 
      $streaming ? Tweet.slack_post_options(tweet) : "この機能は現在停止中です" 
    end
  end
end
