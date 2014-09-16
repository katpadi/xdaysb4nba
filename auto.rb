require 'sinatra'
require 'omniauth-twitter'
require 'twitter'
require 'yaml'
require 'active_support/core_ext/numeric/time'

# Enable Ramon! http://espn.go.com/nba/player/_/id/3231/ramon-sessions
# because You must provide a session to use OmniAuth.
enable :sessions

# TIL -- by default Sinatra looks for Rack handlers with namespace names:
# HTTP and WEBrick, in that order.
# Since the HTTP namespace has been defined Sinatra actually thinks it's a Rack handle
# So unless you use Thin client, you have to explicitly set webrick
set :server, 'webrick'

configure do
  @@config = YAML.load_file("config.yml") rescue nil || {}
end

# Set up omniauth
use OmniAuth::Builder do
  provider :twitter, @@config['api']['consumer_key'], @@config['api']['consumer_secret']
end

helpers do
  def admin?
    session[:admin]
  end

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
    client.update_with_media("OWWW YEAAAH!!! #{get_xdays()}", File.new(img_path))

    # ========= JUST MY NOTES =========
    # OK so posting with just text is easy
    # client.update("Test #{get_xdays()}  #{Time.new.strftime("%Y-%m-%d %H:%M:%S")}")

    # Even posting a tweet with photo on your server is easy
    # client.update_with_media("test wit photo frm local", File.new('lebrick.png'))

    # Tweeting a photo from a URL needs another gem :(
    # client.update_with_media("test wit photo", open(url))
    # ========= JUST MY NOTES =========

  end
end

get '/' do
  send_tweet()
end

get '/logout' do
  session[:admin] = nil
end
