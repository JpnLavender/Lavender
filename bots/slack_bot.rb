require './models.rb'
hear /test/ do |event|
  say "てすと！！！", channel: event.channel
end

# Slappy.start
