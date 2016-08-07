require './models.rb'

puts "SlackBot起動!"

hear /Test/i do |e|
  Slack.send("[OK] ALL System Not Warning")
end

hear /BotStatus/i do |e|
  Slack.send(e, "Delete Streaming -> #{$deleted_streaming}")
  Slack.send(e, "User Streaming -> #{$user_streaming}")
end

#===BotStop===
hear /DeleteStreamingStop/i do |e|
  Slack.send("OK... ,Delete Streaming Stop Setting Now ,Wait Press") 
  Tweet::DeletedStreaming.stop(e, "DeletedStreamingStop")
  Slack.send("Setting All Complete, User Streaming Stop!!-> #{$deleted_streaming}")
end

hear /UserStreamingStop/i do |e|
  Slack.send(e, "OK... ,User Streaming Stop Setting Now ,Wait Press") 
  Tweet::UserStreaming.stop("UserStreamingStop")
  Slack.send(e, "Setting All Complete, User Streaming Stop!!->#{$user_streaming}") 
end

#===BotStart===
hear /DeleteStreamingStart/i do |e|
  Slack.send(e, "OK... ,Delete Streaming Start Setting Now ,Wait Press") 
  Tweet::DeletedStreaming.start(e, "DeletedStreamingStart")
  Slack.send(e, "Setting All Complete, Delete Streaming Start!->#{$user_streaming}") 
end

hear /UserStreamingStart/i do |e|
  Slack.send(e, "OK... ,User Streaming Start Setting Now ,Wait Press") 
  Tweet::UserStreaming.start("UserStreamingStart")
  Slack.send(e,"Setting All Complete, User Streaming Start!->#{$user_streaming}") 
end

Slappy.start
