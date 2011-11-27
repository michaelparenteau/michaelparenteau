$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[..])
Bundler.require(:test)
ENV['RACK_ENV'] = 'test'
require 'app'
require 'rspec'
require 'mocha'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.mock_with :mocha
end

describe "the App" do
  def app
    Sinatra::Application
  end

  it "has a good response" do
    get '/'
    last_response.should be_ok
  end

  it "grabs the latest tweet" do
    foo = mock(:foo => "bar")
    # app.expects(:last_tweet).returns("this is a tweet!")
    get "/"
    # assert last_response.body.include?("this is a tweet!")
  end
end
