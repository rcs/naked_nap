require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'rack/test'
require 'naked_nap'

class TestClass
  def mirror(*args)
    ['mirror',args]
  end

  def onearg(one)
    one
  end

  def broken_method
    this_call_wont_work
  end
end

describe NakedNap do
  include Rack::Test::Methods
  it "requires a class to wrap" do
    expect {
      app = NakedNap.new
    }.to raise_error(ArgumentError)
  end
  it "instantiates with a given class" do
    app = NakedNap.new(TestClass)
    app.should_not be_nil
  end

  def app
    NakedNap.new(TestClass)
  end

  # TODO bare slash case
  describe "Argument parsing" do
    it "handles zero arguments" do
      get '/mirror'
      MultiJson.decode(last_response.body).should == ['mirror',[]]
    end

    it "handles one arguments" do
      get '/mirror/1'
      MultiJson.decode(last_response.body).should == ['mirror',['1']]
    end

    it "handles two arguments" do
      get '/mirror/1/2'
      MultiJson.decode(last_response.body).should == ['mirror',['1','2']]
    end

    it "handles hash arugments" do
      get '/mirror?color=blue&size=large'
      MultiJson.decode(last_response.body).should == ['mirror',[{'color' => 'blue', 'size' => 'large'}]]
    end

    it "handles arg plus hash" do
      get '/mirror/1?color=red&size=medium'
      MultiJson.decode(last_response.body).should == ['mirror',['1',{'color' => 'red', 'size' => 'medium'}]]
    end
  end

  describe "error handling" do
    it "returns 404 on unknown method" do
      get '/nomethod'
      last_response.status.should == 404
    end

    it "returns 400 for not enough args" do
      get '/onearg'
      last_response.status.should == 400
    end

    it "returns 400 for too many args" do
      get '/onearg/1/2'
      last_response.status.should == 400
    end

    it "returns 500 for a broken backend implementation" do
      get '/broken_method'
      last_response.status.should == 500
    end
  end
end
