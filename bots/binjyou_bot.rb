require './models'

random_text = ["たしかに","せやな","それな！","わかるわ！"]
random_kaomoji = ["(・∀・)","(^q^)","ლ(´ڡ`ლ)`)","( ˘ω˘)"].sample

Tweet.config.user do |tweet|
  if tweet.class == Twitter::Tweet
    unless /RT/  =~  tweet.full_text
      puts "Success"
      Tweet.config_rest.update("@#{tweet.user.screen_name} #{random_text}#{random_kaomoji}", options = {in_reply_to_status_id: tweet.id})
    end
  else
    puts "faaaaaa"
  end
end
