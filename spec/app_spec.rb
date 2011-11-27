$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[..])
Bundler.require(:test)
ENV['RACK_ENV'] = 'test'
require 'app'
require 'test/unit'
require 'mocha'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Mocha::API
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_good_response
    get '/'
    assert last_response.ok?
  end

  def test_grabs_latest_tweet
    foo = mock(:foo => "bar")
    foo.bar
    # app.expects(:last_tweet).returns("this is a tweet!")
    get "/"
    # assert last_response.body.include?("this is a tweet!")
  end
end
