require 'twitter'

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
    if object.user.screen_name == "alpdaca"
      slack.post "@irimamekun  あるぱか→#{object.text}"
      puts "Tweet by @ni_sosann"
    end

  end
end
