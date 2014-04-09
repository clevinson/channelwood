require 'sinatra'
require 'ohm'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == ENV['CHANNELWOOD_USERNAME'] and password == ENV['CHANNELWOOD_PASSWORD']
end

if ENV.has_key?('REDISCLOUD_URL')
  redis_url = ENV['REDISCLOUD_URL']
else
  redis_url = "redis://127.0.0.1:6379"
end

Ohm.redis = Redic.new(ENV['REDISCLOUD_URL'] || "redis://127.0.0.1:6379")

class Release < Ohm::Model
  attribute :cat_no
  attribute :artist
  attribute :description
  attribute :title
  attribute :release_date
  attribute :published

  unique :cat_no
  index :cat_no
end

get '/releases' do
  @releases = Release.all.to_a
  erb :releases
end

get '/release/new' do
  erb :release_form
end

delete '/release/:id' do
  release = Release[params[:id]]
  release.delete
end

post '/release/new' do
  begin
    release = Release.create(
      :cat_no => params[:cat_no],
      :artist => params[:artist],
      :title => params[:title],
      :description => params[:description],
      :release_date => params[:release_date],
      :published => (params[:published] == 'on' ? "Published" : "Draft")
    )
    logger.info("Created new release!")
    logger.info("   Id: " + release.id.to_s)
    logger.info("   Cat No: " + release.cat_no.to_s)
    logger.info("   Artist: " + release.artist.to_s)
    logger.info("   Title: " + release.title.to_s)
    logger.info("   Description: " + release.description.to_s)
    logger.info("   Release Date: " + release.release_date.to_s)
    logger.info("   Published: " + release.published.to_s)
    
    redirect '/releases'
  rescue Exception => e
    logger.error(e.message)
    redirect '/releases'
  end
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
  erb :physical, :locals => { :release => Release.with(:cat_no, params[:cat_no]) }
end

get '/digital/:cat_no' do
  "THIS IS THE DIGITAL PAGE 4 #{params['cat_no']}"  
end
