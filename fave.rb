#!/usr/bin/env ruby
require "bundler/setup"

require 'twitter'

require 'yaml'
require 'active_support/core_ext/numeric/time'

CONF = YAML.load_file("config.yml") rescue nil || {}

def favorite_a_tweet()

  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = CONF['api']['consumer_key']
    config.consumer_secret     = CONF['api']['consumer_secret']
    config.access_token        = CONF['access']['token']
    config.access_token_secret = CONF['access']['secret']
  end

  # Put your search terms in config.yml
  hashtags = CONF['hashtags'].join(" OR ") rescue nil || {}

  # generate a random number 1-25
  # Random for unpredictability IDK why
  x = rand(25)

  tweet = client.search("#{hashtags} -rt", :result_type => "mixed", :count => x, :lang => "en").take(x).sample

  #Favorite!
  client.favorite(tweet.id)

  # Log here...
  File.open("faves.log", 'a') { |file| file.puts("#{Time.new.inspect} https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}\n") }
end

#send_tweet()
favorite_a_tweet()
