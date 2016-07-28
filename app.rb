require 'bundler/setup'
Bundler.require
require './models.rb'

get '/Lavender/:swich/:id' do
  case params[:swich]
  when "find_tweet"
    if tweet = Tweet.find_by(tweet_id: params[:id])
    {
      tweet_id: tweet.tweet_id,
      user_name: tweet.user_name,
      text: tweet.text
    }.to_json 
    else
      {error: "404"}.to_json 
    end
  end
end

post '/stocking_tweet' do
  p "Done"
end
