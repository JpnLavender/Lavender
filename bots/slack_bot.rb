require './models.rb'

puts "SlackBot起動!"

hear /Test/i do |e|
  Slack.send("[OK] ALL System Not Warning")
end

hear /BotStatus/i do |e|
  Slack.send(e, "Delete Streaming -> #{$deleted_streaming}")
  Slack.send(e, "User Streaming -> #{$streaming}")
end

#===BotStop===
hear /DeleteStreamingStop/i do |e|
  Slack.send("OK... ,Delete Streaming Start Setting Now ,Wait Press") 
  Tweeted.stop(e, "DeleteBotStop")
  Slack.send("Setting All Complete, User Streaming Stop!!-> #{$deleted_streaming}")
end

hear /StreamingStop/i do |e|
  Slack.send(e, "OK... ,User Streaming Start Setting Now ,Wait Press") 
  Tweeted.stop("StreamingStop")
  Slack.send(e, "Setting All Complete, User Streaming Stop!!->#{$streaming}") 
end

#===BotStart===
hear /DeleteStreamingStart/i do |e|
  Slack.send(e, "OK... ,Delete Streaming Start Setting Now ,Wait Press") 
  Tweeted.start(e, "StreamingStop")
  Slack.send(e, "Setting All Complete, Delete Streaming Start!->#{$streaming}") 
end

hear /UserStreamingStart/i do |e|
  Slack.send(e, "OK... ,User Streaming Start Setting Now ,Wait Press") 
  Tweeted.start("StreamingStop")
  Slack.send(e,"Setting All Complete, User Streaming Start!->#{$streaming}") 
end

Slappy.start
