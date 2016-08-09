require './models.rb'
puts "Ayami_old_Bot"

puts "AyamiBot -> #{$user_streaming}"
Tweet.config.user do |tweet|
  if tweet == Twitter::Tweet
    if tweet.user.screen_name == 'ayamin_talk' && tweet.full_text =~ /彼/
      Tweet.config_rest.update("かつみー" * 3)
    end
  end
end
