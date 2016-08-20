puts "TweetCheckr"
require './models.rb'

puts "ユーザー監視 -> #{$user_streaming}"
favo_user = Tweet.list_join_members(763286476729704449)

Tweet.config.user do |tweet|
  if tweet.class == Twitter::Tweet
    Tweet.database_post(tweet); puts "きたあああああああ"
    case tweet.full_text
    when /社畜ちゃん/
      Slappy.say "#{tweet.user.name}に呼ばれてるよ！\n #{tweet.uri}"
    end
    case tweet.user.screen_name
    when *favo_user
      $user_streaming ? Tweet.slack_post_options(tweet) : "この機能は現在停止中です"
      Tweet.config_rest.favorite(tweet.id)
    end
  end
end
