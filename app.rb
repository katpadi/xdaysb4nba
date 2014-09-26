require 'sinatra'
require 'haml'
require 'open-uri'

get '/' do
  read_from_katpadi()
  follower_count()
  haml :index
end

# If local :P
def read_list()
  @faves_list = File.open('faves.log', 'r').readlines
end

def read_from_katpadi()
  @faves_list  = open('http://katpadi.ph/favelogs/faves.html') {|f| f.readlines }
end

def follower_count()
  followers  = open('http://katpadi.ph/favelogs/followers.html') {|f| f.readlines }
  cunt = Array.new
  followers.each do |line|
    cunt.push(line.split.last)
  end
  @peak = cunt.max
end