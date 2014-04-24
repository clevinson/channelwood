require 'compass'
require 'sinatra'
require 'ohm'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == ENV['CHANNELWOOD_USERNAME'] and password == ENV['CHANNELWOOD_PASSWORD']
end

get '/css/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss :"stylesheets/#{params[:name]}"
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

helpers do
  def get_release(cat_no)
    Release.with(:cat_no, cat_no)
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/releases' do
  @releases = Release.all.to_a
  erb :releases, :layout => :admin_layout
end

get '/release/new' do
  erb :release_new, :layout => :admin_layout
end

get '/release/:cat_no/edit' do
  erb :admin_layout do
    erb :release_edit, :locals => { :release => get_release(params[:cat_no]) }
  end
end

put '/release/:cat_no' do
  release = get_release(params[:cat_no])
  release.artist = params[:artist]
  release.title = params[:title]
  release.description = params[:description]
  release.release_date = params[:release_date]
  release.cat_no = params[:cat_no]
  release.save
  redirect('/releases')
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
  erb :physical,
      :locals => { :release => get_release(params[:cat_no]) }
end

get '/digital/:cat_no' do
  "THIS IS THE DIGITAL PAGE 4 #{params['cat_no']}" + (erb :footer)
end

get '/about' do
  erb :about
end
