require './models.rb'

puts "SlackBot起動!"

hear /test/ do |event|
  say "てすと！！！", channel: event.channel
end

# hear /help|-h/ do |event|
#   say "テスト -> test" , channel: event.channel
#   say "つい消しアラートストップ -> DeleteBotStop", channel: event.channel
#   say "フォロワーストリーミングストップ -> StreamingStop", channel: event.channel
# end

hear /DeleteBotStop|deletetweetstop/ do |event|
  say "了解です!!終了していますので少々お待ちを!!", channel: event.channel 
  Tweet.stop("DeleteBotStop")
  say "つい消しアラートのBotを停止しました!!"
end

hear /StreamingStop|streamingstop/ do |event|
  say "了解です!!終了していますので少々お待ちを!!", channel: event.channel 
  Tweet.stop("StreamingStop")
  say "お気に入りフォロワーストリーミングのBotを停止しました!!", channel: event.channel 
end

Slappy.start
