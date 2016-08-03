Tweet.config.user do |tweet|
  case tweet
  when Twitter::Tweet 
    case tweet
    when /社畜ちゃん/
      Slappy.say "#{tweet.user.name}に呼ばれてるよ！\n #{tweet.uri}"
    end
  end
end
