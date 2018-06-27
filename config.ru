require './app'
require 'rack/reverse_proxy'

use Rack::ReverseProxy do
  reverse_proxy /^\/stash\/(.*)$/, 'http://rosetta.whatbox.ca:63234/stash/$1'
end

run Channelwood
