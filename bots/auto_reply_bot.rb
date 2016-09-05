require './models'
puts "AutoReplyBot"
message = gets

Tweet.config.user do |tweet|
  if tweet.class == Twitter::Tweet && tweet.user.screen_name =~ /sawawankagi|h_ayaha19|hananigashi19|sawasan0519/ 
    unless /RT/  =~  tweet.full_text
      puts "Success"
      Tweet.config_rest.update("@#{tweet.user.screen_name} #{message}", options = {in_reply_to_status_id: tweet.id})
    end
  else
    puts "faaaaaa"
  end
end
