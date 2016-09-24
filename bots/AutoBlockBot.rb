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
    begin
      @rest.block(id)
      puts "SuccessUserBlock! at @#{@rest.user(id).screen_name}"
    rescue
      puts "Block Error"
    end
  end

  def event_stream
    begin
      @stream.user do |event|
        next unless event.is_a?(Twitter::Streaming::Event)
        next unless @events.include?(event.name)
        next if follow_list.include?(event.source.id)
        user_block(event.source.id)
      end
    rescue
      run
    end
  end

end

CONFIG = {
  consumer_key: ENV["MAIN_CONSUMER_KEY"],
  consumer_secret: ENV["MAIN_CONSUMER_SECRET"],
  access_token: ENV["MAIN_ACCESS_TOKEN"],
  access_token_secret: ENV["MAIN_ACCESS_TOKEN_SECRET"]
}

app = AutoBlockBot.new(CONFIG)
app.run

