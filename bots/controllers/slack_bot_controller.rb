require 'slappy'
require 'slappy/dsl'

puts "SlackBot起動!"
class SlackBot
  Slappy.configure do |config|
    config.robot.username   = '藍坂巫女'
    config.robot.channel    = 'bot_tech'
    config.robot.icon_url   = 'http://goo.gl/5sotqB'
  end
end

hear /test/ do |event|
  say "てすと！！！", channel: event.channel
end

# Slappy.start
