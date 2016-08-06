require './models.rb'

puts "SlackBot起動!"

hear /test/i do |event|
  say "[OK] ALL System Not Warning", channel: event.channel
end

hear /status/i do |event|
  say "Delete Streaming -> #{$deleted_streaming}", channel: event.channel
  say "User Streaming -> #{$streaming}", channel: event.channel
end

#===BotStop===
hear /DeleteStreamingStop/i do |event|
  say "OK... ,Delete Streaming Start Setting Now ,Wait Press", channel: event.channel 
  Tweeted.stop("DeleteBotStop")
  say "Setting All Complete, User Streaming Stop!!-> #{$deleted_streaming}", channel: event.channel
end

hear /StreamingStop/i do |event|
  say "OK... ,User Streaming Start Setting Now ,Wait Press", channel: event.channel 
  Tweeted.stop("StreamingStop")
  say "Setting All Complete, User Streaming Stop!!->#{$streaming}", channel: event.channel 
end

#===BotStart===
hear /DeleteStreamingStart/i do |event|
  say "OK... ,Delete Streaming Start Setting Now ,Wait Press", channel: event.channel 
  Tweeted.start("StreamingStop")
  say "Setting All Complete, Delete Streaming Start!->#{$streaming}", channel: event.channel 
end

hear /UserStreamingStart/i do |event|
  say "OK... ,User Streaming Start Setting Now ,Wait Press", channel: event.channel 
  Tweeted.start("StreamingStop")
  say "Setting All Complete, User Streaming Start!->#{$streaming}", channel: event.channel 
end

Slappy.start
