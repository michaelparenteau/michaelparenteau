require "rubygems"
require "bundler/setup"
require "rack"
require "sinatra"
require "sinatra/static_assets"
require "swish"
require "twitter"
require "active_support/cache"

DefaultCacheExpirationTime = 4.hours

set :haml, {:format => :html5}
set :cache, ActiveSupport::Cache::MemoryStore.new(:expires_in => DefaultCacheExpirationTime)

get '/' do
  @page_title = "Artist & Designer at Relevance, Inc. in Durham, NC"
  @tweet = last_tweet
  @shot = last_shot
  haml :index
end

def last_shot
  Dribbble::Player.find('michaelparenteau').shots.first
end

def last_tweet
  settings.cache.fetch(:last_tweet) do
    begin
      Twitter.user_timeline("parenteau").first.text
    rescue => e
      $stderr.puts "Could not retrieve latest tweet!"
      $stderr.puts e
      nil
    end
  end
end
