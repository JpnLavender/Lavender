require './models.rb'

puts "SlackBot起動!"

hear /test|テスト/ do |event|
  say "[OK] ALL System Not Warning", channel: event.channel
end

hear /ClassTest/ do |event|
  say "#{Twitter.class}&#{Twitter}", channel: event.channel
end

# hear /help|-h/ do |event|
#   say "テスト -> test" , channel: event.channel
#   say "つい消しアラートストップ -> DeleteBotStop", channel: event.channel
#   say "フォロワーストリーミングストップ -> StreamingStop", channel: event.channel
# end

hear /DeleteBotStop|deletetweetstop/ do |event|
  say "了解です!!終了していますので少々お待ちを!!", channel: event.channel 
  Tweet.stop("DeleteBotStop")
  say "つい消しアラートのBotを停止しました!! -> #{$deleted_streaming}"
end

hear /StreamingStop|streamingstop/ do |event|
  say "了解です!!終了していますので少々お待ちを!!", channel: event.channel 
  Tweet.stop("StreamingStop")
  say "お気に入りフォロワーストリーミングのBotを停止しました!!->#{$streaming}", channel: event.channel 
end

Slappy.start
