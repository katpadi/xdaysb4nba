#!/usr/bin/env ruby
require "bundler/setup"

require 'twitter'

require 'yaml'
require 'active_support/core_ext/numeric/time'

def init()
  @CONF = YAML.load_file("config.yml") rescue nil || {}

  if @CONF['hashtags'].to_a.empty?
    puts "No hashtags!"
    exit
  end
end

def client_init()
  @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = @CONF['api']['consumer_key']
    config.consumer_secret     = @CONF['api']['consumer_secret']
    config.access_token        = @CONF['access']['token']
    config.access_token_secret = @CONF['access']['secret']
  end
end

def favorite_a_tweet()

  @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = @CONF['api']['consumer_key']
    config.consumer_secret     = @CONF['api']['consumer_secret']
    config.access_token        = @CONF['access']['token']
    config.access_token_secret = @CONF['access']['secret']
  end
  # Put your search terms in config.yml
  hashtags = @CONF['hashtags'].join(" OR ")

  tweet = @client.search("#{hashtags} -rt", :result_type => "mixed", :lang => "en").to_a.sample

  #Favorite!
  @client.favorite(tweet.id)

  # Log here...
  File.open("faves.log", 'a') { |file| file.puts("#{Time.new.inspect} https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}\n") }
end

def check_followers_count()
  x = @client.user.followers_count()
  # Log here...
  File.open("followers.log", 'a') { |file| file.puts("#{Time.new.inspect} #{x}\n") }
end

# Ito daw parang main
if __FILE__ == $0
  init()
  client_init()
  favorite_a_tweet()
  check_followers_count()
end