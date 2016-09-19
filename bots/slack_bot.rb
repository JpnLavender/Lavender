require './models.rb'

puts "SlackBotBot起動!"

hear /^Test/i do |e|
  SlackBot.send(e, "[OK] ALL System Not Warning")
end

hear /^BotStatus/i do |e|
  SlackBot.send(e, "Delete Streaming -> #{$deleted_streaming}")
  SlackBot.send(e, "User Streaming -> #{$user_streaming}")
end

hear /^Tw: / do |e|
  Tweet.tweet( e.text.delete("Tw: "))
  SlackBot.send(e, "Success!Tweet!")
end

Slappy.start
