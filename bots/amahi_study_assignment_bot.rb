require './models'
puts "study_assignment_bot"

Tweet.config.user do |tweet|
  if tweet.is_a?(Twitter::Tweet) && tweet.user.screen_name == /sawawankagi|h_ayaha19|hananigashi19|sawasan0519/ 
    Tweet.config_rest.update("@#{object.user.screen_name} #{"課題" * 30}", options = {in_reply_to_status_id: object.id})
  end
end
