require 'bundler/setup'
Bundler.require

# p ActiveRecord::Base.configurations = YAML.load_file('database.yml')
# ActiveRecord::Base.establish_connection(ENV['RACK_ENV'])

config = YAML.load_file( './database.yml' )
ActiveRecord::Base.establish_connection(config["development"])

after do
  ActiveRecord::Base.connection.close
end

class Tweet < ActiveRecord::Base; end
