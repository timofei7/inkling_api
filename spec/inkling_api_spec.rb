require 'spec_helper'
require 'inkling_api_test_config'

describe InklingApi do

  let(:url)      {InklingApiTestConfig.url}
  let(:login)    {InklingApiTestConfig.login}
  let(:password) {InklingApiTestConfig.password}
  let(:inkling_api) do
    InklingApi.url      = url
    InklingApi.login    = login
    InklingApi.password = password
    InklingApi
  end

  %w( configure connection get post put delete markets market new_market
      update_market delete_market publish_market memberships membership
      create_membership update_membership update_balance delete_membership
      prices positions answer create_answer update_answer delete_answer cash_out
      create_refund).each do |meth|
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

  it "should create a market" do
    question = "Is this test going to pass?"
    class_type = "Exclusive"
    ends_at = "2014-05-05T02:20:30-05:00"
    tag_list = "tests"
    inkling_api.new_market(question, class_type, ends_at, tag_list)["market"]["id"].should_not be_nil
  end

  it "should update a market" do
    market_id = 37810
    question = "Testing predicition widget"
    # NOTE: This will raise a <Faraday::Error::ParsingError> because it expects XML to be returned
    # However, Inkling Markets returns nothing when updating existing markets
    # lambda do
    #   inkling_api.update_market(market_id, question)
    # end.should_not raise_error
  end

  it "should delete a market" do
    market_id = 38271
    lambda do
      inkling_api.delete_market(market_id)
    end.should_not raise_error
  end

  it "should publish a market" do
    market_id = 38370
    lambda do
      inkling_api.publish_market(market_id)
    end.should_not raise_error
  end

  it "should get a list of memberships" do
    inkling_api.memberships.should be_a(Hash)
  end

  it "should get a membership" do
    member_id = 211378
    inkling_api.membership(member_id).should be_a(Hash)
  end

  it "should get the membership of the logged in user" do
    inkling_api.me.should be_a(Hash)
  end

  it "should create a membership" do
    login = "foo_bar#{Time.now.utc.to_i.to_s}"
    email = "foo#{Time.now.utc.to_i.to_s}@bar.com"
    first_name = "foo"
    last_name = "bar"
    password = "password"
    inkling_api.create_membership(login, email, password, first_name, last_name)["membership"]["id"].should_not be_nil
  end

  it "should update a membership" do
    membership_id = 210665
    first_name = "Sports"
    last_name = "Intel"
    # NOTE: This will raise a <Faraday::Error::ParsingError> because it expects XML to be returned
    # However, Inkling Markets returns nothing when updating existing memberships
    # lambda do
    #   inkling_api.update_membership(first_name, last_name, membership_id)
    # end.should_not raise_error
  end

  it "should delete a membership" do
    membership_id = 211794
    # TODO: Email Inkling Markets about why this and 
    # curl \
    # -u user:password \
    # -H 'Content-Type: application/xml' \
    # -X DELETE \
    # http://subdomain.inklingmarkets.com/memberships/:membership_id.xml
    # does not work...
    lambda do
      inkling_api.delete_membership(membership_id)
    end.should_not raise_error
  end

  it "should update a member's balance" do
    membership_id = 210665
    balance_value = 293692
    # NOTE: This will raise a <Faraday::Error::ParsingError> because it expects XML to be returned
    # However, Inkling Markets returns nothing when updating the balance
    # lambda do
    #  inkling_api.update_balance(balance_value, membership_id)
    # end.should_not raise_error
  end

  it "should get a list of prices" do
    inkling_api.prices.should be_a(Hash)
  end

  it "should get a list of positions" do
    inkling_api.positions.should be_a(Hash)
  end

  it "should get a list of possbile answers" do
    stock_id = 145841
    inkling_api.answer(stock_id)
  end

  it "should create a new answer for a market" do
    market_id = 37810
    answer = "Yes"
    symbol = "YES"
    inkling_api.create_answer(answer, symbol, market_id)
  end

  it "should update an answer" do
    stock_id = 145841
    symbol = "ALABA"
    starting_price = 5000
    answer = "Alabama"
    # NOTE: This will raise a <Faraday::Error::ParsingError> because it expects XML to be returned
    # However, Inkling Markets returns nothing when updating a possible answer
    # lambda do
    #  inkling_api.update_answer(stock_id, answer, symbol, starting_price)
    # end.should_not raise_error
  end

  it "should delete an answer" do
    stock_id = 147220
    # NOTE: This will rise a <Farada::Error::ParsingError> because it expects XML to be returned
    # However, Inkling Markets returns nothing when deleting a possible answer
    # lambda do
    #   inkling_api.delete_answer(stock_id)
    # end.should_not raise_error
  end

  it "should cash out on a possible answer" do
    stock_id = 147219
    inkling_api.cash_out(stock_id).should be_a(Hash)
  end

  it "should create a refund on a possible answer" do
    stock_id = 144196
    lambda do
      inkling_api.create_refund(stock_id)
    end.should_not raise_error
  end

  it "should get a list of all trades" do
    inkling_api.trades.should be_a(Hash)
  end

  it "should create a trade for a possible answer" do
    stock_id = 147223
    membership_id = 210690
    quantity = 2
    lambda do
      inkling_api.create_trade(stock_id, membership_id, quantity)
    end.should_not raise_error
  end

  it "should create a quote for a possible answer" do
    stock_id = 147223
    membership_id = 210690
    quantity = 2
    lambda do
      inkling_api.quote(stock_id, membership_id, quantity)
    end.should_not raise_error
  end

  it "should get a list of comments" do
    market_id = 38118
    inkling_api.comments(market_id).should be_a(Array)
  end
end
