require './models'
puts "study_assignment_bot"

Tweet.config.user do |tweet|
  if tweet.class == Twitter::Tweet && tweet.user.screen_name =~ /sawawankagi|h_ayaha19|hananigashi19|sawasan0519/ 
    puts "Success"
    Tweet.config_rest.update("@#{tweet.user.screen_name} 課題しろ！！！", options = {in_reply_to_status_id: tweet.id})
  else
    puts "faaaaaa"
  end
end
