require './models.rb'

puts "SlackBotBot起動!"

hear /^Test/i do |e|
  SlackBot.send(e, "[OK] ALL System Not Warning")
end

hear /^BotStatus/i do |e|
  SlackBot.send(e, "Delete Streaming -> #{$deleted_streaming}")
  SlackBot.send(e, "User Streaming -> #{$user_streaming}")
end

hear /^help|-h /i do |e|
  SlackBot.send(e,
                "
                SlackBot動作テスト: 'Test'\n
                TwitterBot動作テスト: 'BotStatus'\n
                つい消しアラート停止&再開: 'DeletedStreaming Stop | Start'\n
                ユーザー監視停止&再開: 'UserStreaming Stop | Start'\n
                ツイート: 'Tweet: hogefuga'\n
                ")
end

#===BotStop===
hear /^DeleteStreamingStop/i do |e|
  SlackBot.send("OK... ,Delete Streaming Stop Setting Now ,Wait Press")
  Tweet::DeletedStreaming.stop!
  SlackBot.send("Setting All Complete, User Streaming Stop!!-> #{$deleted_streaming}")
end

hear /^UserStreamingStop/i do |e|
  SlackBot.send(e, "OK... ,User Streaming Stop Setting Now ,Wait Press")
  Tweet::UserStreaming.stop!
  SlackBot.send(e, "Setting All Complete, User Streaming Stop!!->#{$user_streaming}")
end

#===BotStart===
hear /^DeleteStreamingStart/i do |e|
  SlackBot.send(e, "OK... ,Delete Streaming Start Setting Now ,Wait Press")
  Tweet::DeletedStreaming.start!
  SlackBot.send(e, "Setting All Complete, Delete Streaming Start!->#{$user_streaming}")
end

hear /^UserStreamingStart/i do |e|
  SlackBot.send(e, "OK... ,User Streaming Start Setting Now ,Wait Press")
  Tweet::UserStreaming.start!
  SlackBot.send(e,"Setting All Complete, User Streaming Start!->#{$user_streaming}")
end

hear /^Tw: / do |e|
  Tweet.tweet( e.text.delete("Tw: "))
  SlackBot.send(e, "Success!Tweet!")
end

Slappy.start
