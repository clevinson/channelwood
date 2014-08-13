require 'aws-sdk'
require 'compass'
require 'sinatra'
require 'ohm'
require 'ohm/contrib'
require './channelwood-models'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == ENV['CHANNELWOOD_USERNAME'] and password == ENV['CHANNELWOOD_PASSWORD']
end

get '/css/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss :"stylesheets/#{params[:name]}"
end

$s3 = AWS::S3.new
Ohm.redis = Redic.new(ENV['REDISCLOUD_URL'] || "redis://127.0.0.1:6379")

helpers do
  def get_release(cat_no)
    Release.with(:cat_no, cat_no)
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end

  def s3_images
    $s3.buckets['wip-static'].objects.with_prefix('release-artwork/').select do |object|
      object.key[-1] != '/'
    end.collect do |object|
      object.public_url
    end
  end
end

get '/releases' do
  @releases = Release.all.to_a
  erb :releases, :layout => :admin_layout
end

get '/release/new' do
  erb :release_new, :layout => :admin_layout, :locals => { :images => s3_images }
end

get '/release/:cat_no/edit' do
  release = get_release(params[:cat_no])
  erb :admin_layout do
    erb :release_edit, :locals => { :release => get_release(params[:cat_no]), :images => s3_images}
  end
end

put '/release/:cat_no' do
  release = get_release(params[:cat_no])
  release.artist = params[:artist]
  release.title = params[:title]
  release.description = params[:description]
  release.cover_art = params[:cover_art]
  release.images = params[:images] || []
  release.release_date = params[:release_date]
  release.published = (params[:published] == 'on' ? "Published" : "Draft")
  release.save
  redirect('/releases')
end


delete '/release/:id' do
  release = Release[params[:id]]
  release.delete
end

post '/release/new' do
  logger.info("Found params: #{params}")
  begin
    release = Release.create(
      :cat_no => params[:cat_no],
      :artist => params[:artist],
      :title => params[:title],
      :description => params[:description],
      :cover_art => params[:cover_art],
      :images => params[:images] || [],
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
  erb :splash
end

get '/home' do
  erb :home
end

get '/physical/:cat_no' do
  release = get_release(params[:cat_no])
  background_images = release.images

  erb :physical,
      :locals => { :release => release, :background_images => background_images }
end

get '/digital/:cat_no' do
  "THIS IS THE DIGITAL PAGE 4 #{params['cat_no']}" + (erb :footer)
end

get '/about' do
  erb :about
end
