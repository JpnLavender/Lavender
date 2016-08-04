class AddScreenNameToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :screen_name, :string
    add_column :tweets, :color, :string
  end
end
