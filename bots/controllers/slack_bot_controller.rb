require 'slappy'
require 'slappy/dsl'

Slappy.configure do |config|
  config.robot.username   = '藍坂巫女'
  config.robot.channel    = 'bot_tech'
  config.robot.icon_url   = 'http://goo.gl/5sotqB'
end


class Slack
  def self.send(message)
    say(message)
  end
end


