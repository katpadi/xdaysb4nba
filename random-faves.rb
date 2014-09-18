#!/usr/bin/env ruby
require "bundler/setup"

require 'twitter'

require 'yaml'
require 'active_support/core_ext/numeric/time'

CONF = YAML.load_file("config.yml") rescue nil || {}

def search_random()

  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = CONF['api']['consumer_key']
    config.consumer_secret     = CONF['api']['consumer_secret']
    config.access_token        = CONF['access']['token']
    config.access_token_secret = CONF['access']['secret']
  end

  # Put your search terms in config.yml
  hashtags = CONF['hashtags'].join(" OR ")

  #favorite_this = searches.sample
  puts hashtags

  # generate a random number 1-25
  # According to its docs, 100 is twitter's max but it's not allowing me to do so
  x = rand(25)
  puts x
  test = client.search("#{hashtags} -rt", :result_type => "mixed", :count => x, :lang => "en").take(x).sample
  #puts test.text
  #puts test.id
  #puts test.user.screen_name
  client.favorite(test.id)

  # Log here...
end

#send_tweet()
search_random()
