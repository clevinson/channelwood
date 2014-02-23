require 'sinatra'

get '/' do
  erb :index
end

get '/buttweasel' do
  "matt is smelly"
end