require 'bundler/setup'
Bundler.require
after do
  ActiveRecord::Base.connection.close
end

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_secure_password
  validates :mail, presence: true, format: {with:/.+@.+/} 
  validates :password, confirmation: true,
    unless: Proc.new { |a| a.password.blank? }
end

class Stock < ActiveRecord::Base
end
