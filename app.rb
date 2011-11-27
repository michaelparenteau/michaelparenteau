require "rubygems"
require "bundler/setup"
require "rack"
require "sinatra"
require 'sinatra/static_assets'
require 'swish'
require 'twitter'

# FOR BASIC AUTH USE BELOW, REPLACE ['username', 'password'] with actual credentials
# use Rack::Auth::Basic do |username, password|
#   [username, password] == ['username', 'password']
# end

set :haml, {:format => :html5}

get '/' do
  @page_title = "Artist & Designer at Relevance, Inc. in Durham, NC"
  # @tweet = Twitter.user_timeline("parenteau").first.text
  @player = Dribbble::Player.find('michaelparenteau')
  @shot = @player.shots.first

  haml :index
end
