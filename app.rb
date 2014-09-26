require 'sinatra'
require 'haml'

get '/' do
  read_list()
  haml :index
end

def read_list
  @faves_list = File.open('faves.log', 'r').readlines
end