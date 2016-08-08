require 'slappy'
require 'slappy/dsl'

Slappy.configure do |config|
  config.robot.username   = '藍坂巫女'
  config.robot.channel    = 'bot_tech'
  config.robot.icon_url   = 'http://goo.gl/5sotqB'
end

class SlackBot
  def self.send(event, message)
    Slappy.say (message), channel: event.channel
  end
end
