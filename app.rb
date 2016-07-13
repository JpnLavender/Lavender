require 'slack/incoming/webhooks'
require 'twitter'
require 'slack-ruby-bot'
require 'slack-ruby-client'
require 'slack'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
p "テストん"
slack = Slack::Incoming::Webhooks.new ENV["SLACK_URL"]

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key    = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.access_token    = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end

client_rest = Twitter::REST::Client.new do |config|
  config.consumer_key    = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.access_token    = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end



client.user do |object|
  if object.is_a?(Twitter::Tweet)
    if object.text =~ /テスト/
      client_rest.favorite(object.id)
      slack.post "生存確認を検知レスポンスを返します..."
      puts "生存確認を検知レスポンスを返します..."
    end
    if object.user.screen_name == "ni_sosann"
      slack.post "@irimamekun  ママ！→#{object.text}"
      puts "Tweet by @ni_sosann"
    end
    if object.user.screen_name == "yukapote01041"
      slack.post "@irimamekun  ゆかさん→#{object.text}"
      puts "Tweet by @yukapote01041"
    end
    if object.user.screen_name == "alpdaca"
      slack.post "@irimamekun  あるぱか→#{object.text}"
      puts "Tweet by @ni_sosann"
    end

  end
end
