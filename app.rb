require 'bundler/setup'
Bundler.require
require './models.rb'

get 'Lavender/:swich/:id' do
  case params[:swich]
  when find_tweet
    p tweet = Tweet.find_by(tweet_id: params[:id])
  end
end
