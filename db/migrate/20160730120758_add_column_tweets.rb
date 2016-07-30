class AddColumnTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :icon, :string
    add_column :tweets, :url, :string
    add_column :tweets, :media, :string
  end
end
