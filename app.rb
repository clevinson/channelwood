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
  property :description, Text
  property :title, String
  property :public, Boolean
end

Release.finalize

get '/releases' do
  @releases = Release.all
  erb :releases
end

get '/releases/add' do
  erb :release_form
end

post '/releases/add' do
  release = Release.create(
    :cat_no => params[:cat_no],
    :artist => params[:artist],
    :title => params[:title],
    :description => params[:description]
  )
  logger.info("Created new release!")
  logger.info("   Id: " + release.id.to_s)
  logger.info("   Cat No: " + release.cat_no.to_s)
  logger.info("   Artist: " + release.artist.to_s)
  logger.info("   Title: " + release.title.to_s)
  logger.info("   Description: " + release.description.to_s)
  redirect '/releases'
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
