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

  before do
    # Don't allow any real http requests -- we don't want Dribble or Twitter
    # requests happening during test runs
    FakeWeb.allow_net_connect = false
  end

  it "has a good response" do
    app.any_instance.stubs(:last_shot).returns(stub_everything("dribble shot"))
    app.any_instance.stubs(:last_tweet).returns("some tweet")
    get '/'
    last_response.should be_ok
  end

  it "shows friendly error message if tweets can't be loaded" do
    app.any_instance.stubs(:last_shot).returns(stub_everything("dribble shot"))
    app.any_instance.expects(:last_tweet).returns(nil)
    get "/"
    last_response.body.should include("Twitter requests are timing out")
  end

  it "shows friendly error message if twitter raises an exception" do
    app.any_instance.stubs(:last_shot).returns(stub_everything("dribble shot"))
    Twitter.expects(:user_timeline).raises(RuntimeError)
    get "/"
    last_response.body.should include("Twitter requests are timing out")
  end

  it "shows the latest tweet" do
    app.any_instance.stubs(:last_shot).returns(stub_everything("dribble shot"))
    app.any_instance.expects(:last_tweet).returns("this is a tweet!")
    get "/"
    last_response.body.should include("this is a tweet!")
  end
end
