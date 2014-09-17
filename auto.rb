#!/usr/bin/env ruby
require "bundler/setup"

require 'twitter'

require 'yaml'
require 'active_support/core_ext/numeric/time'


@@config = YAML.load_file("config.yml") rescue nil || {}

def get_xdays()
  Time.zone = 'Singapore'
  x_days = (Time.zone.parse(@@config['misc']['target_date'])- Time.zone.now).to_i/1.day
end

def send_tweet()
  # Set up twitter
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = @@config['api']['consumer_key']
    config.consumer_secret     = @@config['api']['consumer_secret']
    config.access_token        = @@config['access']['token']
    config.access_token_secret = @@config['access']['secret']
  end

  # Check if there is a file
  # I made the image names the # on jersey
  File.file?("images/#{get_xdays()}.jpg") ? img_path = "images/#{get_xdays()}.jpg" : img_path = "images/404.jpg"

  # Use it to tweet!!!
  client.update_with_media("Owww yeah!!! There are only #{get_xdays()} days left before the @NBA starts. Let's go @Lakers!", File.new(img_path))

  # ========= JUST MY NOTES =========
  # OK so posting with just text is easy
  # client.update("Test #{get_xdays()}  #{Time.new.strftime("%Y-%m-%d %H:%M:%S")}")

  # Even posting a tweet with photo on your server is easy
  # client.update_with_media("test wit photo frm local", File.new('lebrick.png'))

  # Tweeting a photo from a URL needs another gem :(
  # client.update_with_media("test wit photo", open(url))
  # ========= JUST MY NOTES =========

end


send_tweet()