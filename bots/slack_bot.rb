require './models.rb'

puts "SlackBot起動!"

hear /test/i do |event|
  Slack.send("[OK] ALL System Not Warning")
end

hear /status/i do |event|
  Slack.send("Delete Streaming -> #{$deleted_streaming}")
  Slack.send("User Streaming -> #{$streaming}")
end

#===BotStop===
hear /DeleteStreamingStop/i do |event|
  Slack.send("OK... ,Delete Streaming Start Setting Now ,Wait Press") 
  Tweeted.stop("DeleteBotStop")
  Slack.send("Setting All Complete, User Streaming Stop!!-> #{$deleted_streaming}")
end

hear /StreamingStop/i do |event|
  Slack.send("OK... ,User Streaming Start Setting Now ,Wait Press") 
  Tweeted.stop("StreamingStop")
  Slack.send("Setting All Complete, User Streaming Stop!!->#{$streaming}") 
end

#===BotStart===
hear /DeleteStreamingStart/i do |event|
  Slack.send("OK... ,Delete Streaming Start Setting Now ,Wait Press") 
  Tweeted.start("StreamingStop")
  Slack.send("Setting All Complete, Delete Streaming Start!->#{$streaming}") 
end

hear /UserStreamingStart/i do |event|
  Slack.send( "OK... ,User Streaming Start Setting Now ,Wait Press") 
  Tweeted.start("StreamingStop")
  Slack.send("Setting All Complete, User Streaming Start!->#{$streaming}") 
end

Slappy.start
