require './models.rb'
puts "Ayami_old_Bot"

Tweet.config.user do |tweet|
  if tweet.class == Twitter::Tweet && tweet.user.screen_name == 'ayamin_talk' && tweet.full_text =~ /彼/
    Tweet.config_rest.update("@#{object.user.screen_name} #{"かつみー" * 3}", options = {in_reply_to_status_id: object.id})
  end
end
