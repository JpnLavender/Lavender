class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id 
      t.string :user_name
      t.text :text
      t.string :img_url
    end
  end
end
