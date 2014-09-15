require 'sinatra'
require 'omniauth-twitter'
require 'twitter'
require 'yaml'

# Enable Ramon! http://espn.go.com/nba/player/_/id/3231/ramon-sessions
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

# Set up twitter
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = @@config['api']['consumer_key']
  config.consumer_secret     = @@config['api']['consumer_secret']
  config.access_token        = @@config['access']['token']
  config.access_token_secret = @@config['access']['secret']
end

helpers do
  def admin?
    session[:admin]
  end
end

get '/' do
  "wassup"
  "<a href='/login'>Log In!!!</a>"
end

get '/public' do
  "If I want a public page..."
end

get '/private' do
  halt(401,'Not Authorized') unless admin?
  "Testing private page - members only"
end

get '/login' do
  redirect to("/auth/twitter")
end

get '/logout' do
  session[:admin] = nil
  "You are now logged out"
end

get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
  "You are logged in"
  # post tweet
  client.update("Test using yaml  #{Time.new.strftime("%Y-%m-%d %H:%M:%S")}")
  "<h1>Hi #{env['omniauth.auth']['info']['name']}!</h1><img src='#{env['omniauth.auth']['info']['image']}'>"
  "<h2>A tweet has been posted using your account!!!</h2>"
end

get '/auth/failure' do
  params[:message]
end