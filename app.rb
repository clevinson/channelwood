require 'sinatra'
require 'dm-core'
require 'dm-redis-adapter'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == ENV['CHANNELWOOD_USERNAME'] and password == ENV['CHANNELWOOD_PASSWORD']
end

redisUri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
uri = URI.parse(redisUri) 
Redis.current = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

DataMapper.setup(:default, {:adapter  => "redis"})

class Release
  include DataMapper::Resource

  property :id, Serial
  property :cat_no, String
  property :artist, String
  property :title, String
end

Release.finalize

get '/release/create' do
  release = Release.create(
    :cat_no => params[:cat_no],
    :artist => params[:artist],
    :title => params[:title]
  )
  "Created release: #{release.to_s}"
end

get '/release/:cat_no' do
  rel = Release.first(:cat_no => params[:cat_no])
  "Artist: #{rel.artist}, Title: #{rel.title}"
end

get '/releases' do
  Release.all.map do |release|
    release.title
  end.join(", ")
end


get '/' do
  erb :index
end

get '/splash' do
  erb :splash
end

get '/home' do
  erb :home
end

get '/physical/:cat_no' do
  erb :physical, :locals => {:cat_no => params[:cat_no] }
end


get '/digital/:cat_no' do
  "THIS IS THE DIGITAL PAGE 4 #{params['cat_no']}"  
end
  

get '/buttweasel' do
  "matt is smelly"
end
