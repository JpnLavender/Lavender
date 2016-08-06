require './models.rb'

puts "SlackBot起動!"

hear /test|テスト/ do |event|
  say "[OK] ALL System Not Warning", channel: event.channel
end

hear /status|Status/ do |event|
  say "Delete Streaming -> #{$deleted_streaming}", channel: event.channel
  say "User Streaming -> #{$streaming}", channel: event.channel
end

#===BotStop===
hear /DeleteStreamingStop/ do |event|
  say "OK... ,Delete Streaming Start Setting Now ,Wait Press", channel: event.channel 
  Tweeted.stop("DeleteBotStop")
  say "Setting All Complete, User Streaming Stop!!-> #{$deleted_streaming}", channel: event.channel
end

hear /StreamingStop/ do |event|
  say "OK... ,User Streaming Start Setting Now ,Wait Press", channel: event.channel 
  Tweeted.stop("StreamingStop")
  say "Setting All Complete, User Streaming Stop!!->#{$streaming}", channel: event.channel 
end

#===BotStart===
hear /DeleteStreamingStart/ do |event|
  say "OK... ,Delete Streaming Start Setting Now ,Wait Press", channel: event.channel 
  Tweeted.start("StreamingStop")
  say "Setting All Complete, Delete Streaming Start!->#{$streaming}", channel: event.channel 
end

hear /UserStreamingStart/ do |event|
  say "OK... ,User Streaming Start Setting Now ,Wait Press", channel: event.channel 
  Tweeted.start("StreamingStop")
  say "Setting All Complete, User Streaming Start!->#{$streaming}", channel: event.channel 
end

Slappy.start
