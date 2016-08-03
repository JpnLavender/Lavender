require 'slappy'

class SlackBot
  def self.config
    Slappy.configure do |config|
      config.robot.username   = '藍坂巫女'
      config.robot.channel    = 'bot_tech'
      config.robot.icon_url   = 'http://goo.gl/5sotqB'
    end
  end
end
