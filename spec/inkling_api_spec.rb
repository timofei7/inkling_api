require 'spec_helper'
require 'ruby-debug'
require 'inkling_api_test_config'

describe InklingApi do

  let(:url)      {InklingApiTestConfig.url}
  let(:login)    {InklingApiTestConfig.login}
  let(:password) {InklingApiTestConfig.password}
  let(:inkling_api) do
    InklingApi.url = url
    InklingApi.login = login
    InklingApi.password = password
    InklingApi
  end

  %w( configure connection get markets market ).each do |meth|
    it "should respond to #{meth}" do
      inkling_api.should respond_to(meth.to_sym)
    end
  end

  it "should not raise error on getting a connection" do
    lambda{ inkling_api.connection }.should_not raise_error
  end

  it "should get a list of markets" do
    inkling_api.markets.should be_an(Array)
  end

  # NOTE: This will only work if the markets aren't empty
  it "should get a market" do
    markets = inkling_api.markets
    inkling_api.market(markets.first["id"]).should be_a(Hash)
  end
end
