require 'bundler/setup'
Bundler.require
require './models.rb'
require 'json'

get '/' do
  "OPPAI"
end

get '/Lavender/:swich/:id' do
  case params[:swich]
  when "find_tweet"
    if tweet = Tweet.find_by(tweet_id: params[:id])
    { tweet_id: tweet.tweet_id, user_name: tweet.user_name, text: tweet.text , icon: tweet.icon, url: tweet.url}.to_json 
    else
      {error: "404"}.to_json 
    end
  end
end

post '/stocking_tweet' do
  Tweet.create(tweet_id: params["tweet_id"], user_name: params["user_name"], text: params["text"])
end
