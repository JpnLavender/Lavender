require './models.rb'

puts "SlackBot起動!"

hear /test/i do |event|
  SlackBot.send("[OK] ALL System Not Warning")
end

hear /status/i do |event|
  "Delete Streaming -> #{$deleted_streaming}")
  SlackBot.send("User Streaming -> #{$streaming}")
end

#===BotStop===
hear /DeleteStreamingStop/i do |event|
  SlackBot.send("OK... ,Delete Streaming Start Setting Now ,Wait Press") 
  Tweeted.stop("DeleteBotStop")
  SlackBot.send("Setting All Complete, User Streaming Stop!!-> #{$deleted_streaming}")
end

hear /StreamingStop/i do |event|
  SlackBot.send("OK... ,User Streaming Start Setting Now ,Wait Press") 
  Tweeted.stop("StreamingStop")
  SlackBot.send("Setting All Complete, User Streaming Stop!!->#{$streaming}") 
end

#===BotStart===
hear /DeleteStreamingStart/i do |event|
  SlackBot.send("OK... ,Delete Streaming Start Setting Now ,Wait Press") 
  Tweeted.start("StreamingStop")
  SlackBot.send("Setting All Complete, Delete Streaming Start!->#{$streaming}") 
end

hear /UserStreamingStart/i do |event|
  SlackBot.send( "OK... ,User Streaming Start Setting Now ,Wait Press") 
  Tweeted.start("StreamingStop")
  SlackBot.send("Setting All Complete, User Streaming Start!->#{$streaming}") 
end

Slappy.start
