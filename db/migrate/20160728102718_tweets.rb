class Tweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.string :tweet_id 
      t.string :user_name
      t.text :text
      t.string :img_url
      t.string :string
      t.string :url
      t.string :media
      t.string :screen_name
      t.string :color
    end
  end
end
