require 'bundler/setup'
Bundler.require
require 'sinatra/reloader'
require './models.rb'
require 'json'

get '/' do
  "OPPAI"
end

get '/Lavender/:swich/:id' do
  case params[:swich]
  when "find_tweet"
    if tweet = Tweet.find_by(tweet_id: params[:id])
      { 
        tweet_id: tweet.tweet_id,
        user: {
          name: tweet.screen_name,
          screen_name: tweet.user_name,
          profile_image_url: tweet.icon,
          profile_link_color: tweet.color 
        }, 
        full_text: tweet.text,
        uri: tweet.url 
      }.to_json 
    else
      {error: "404"}.to_json 
    end
  end
end

post '/stocking_tweet', provides: :json do
  data = JSON.parse(request.body.read)
  Tweet.create(
    tweet_id: data["tweet_id"],
    screen_name: data["name"],
    user_name: data["user_name"],
    text: data["text"],
    icon: data["icon"],
    url: data["url"],
    color: data["color"]
  )
end
