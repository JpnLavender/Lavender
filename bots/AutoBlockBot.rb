require 'twitter'

class AutoBlockBot
  def initialize(config)
    @config = config
    @rest = Twitter::REST::Client.new(@config)
    @stream = Twitter::Streaming::Client.new(@config)
    @events = [:follow, :unfollow].freeze
  end
  attr_reader :config, :rest, :stream, :events

  def run
    event_stream
  end

  def follow_list
    @rest.friend_ids
  end

  def user_block(id)
    data = @rest.status(id)
    @rest.block(id)
    puts "SuccessUserBlock! at #{data.user.name}"
  end

  def event_stream
    @stream.user do |event|
      next unless event.is_a?(Twitter::Streaming::Event)
      next unless @events.include?(event.name)
      next if follow_list.include?(event.source.id)
      user_block(event.source.id)
    end
  end

end

CONFIG = {
  consumer_key: ENV["SUB_CONSUMER_KEY"],
  consumer_secret: ENV["SUB_CONSUMER_SECRET"],
  access_token: ENV["SUB_ACCESS_TOKEN"],
  access_token_secret: ENV["SUB_ACCESS_TOKEN_SECRET"]
}

app = AutoBlockBot.new(CONFIG)
app.run

