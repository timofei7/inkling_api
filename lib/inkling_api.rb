require 'faraday_stack'
require 'inkling_api/faraday_middlewares'
require 'hashie/mash'
require 'inkling_api/activesupport_yaml_hack'
require 'ruby-debug'

module InklingApi
  module Configuration
    def configure
      yield self
    end
  end

  class Mashify < Faraday::Response::Middleware
    def on_complete(env)
      super if Hash === env[:body]
    end

    def parse(body)
      Hashie::Mash.new(body)
    end
  end

  class PreserveRawBody < Faraday::Response::Middleware
    def on_complete(env)
      env[:raw_body] = env[:body]
    end
  end

  module Connection
    def url=(url)
      @url = url
    end

    def login=(login)
      @login = login
    end

    def password=(password)
      @password = password
    end

    def connection
      raise "set_url first" unless @url
      @connection ||= begin
        conn = Faraday.new(@url) do |b|
          b.use Faraday::Request::UrlEncoded
          b.use FaradayStack::ResponseJSON, content_type: 'application/json'
          b.use FaradayMiddlewares::ResponseXMLToHash, content_type: 'application/xml'
          b.use PreserveRawBody
          #b.use FaradayStack::Caching, cache, strip_params: %w[access_token client_id] unless cache.nil?
          #b.response :raise_error
          #b.use Faraday::Response::Logger
          b.use FaradayStack::Instrumentation
          b.adapter Faraday.default_adapter
          b.use Mashify
        end

        conn.basic_auth(@login, @password)

        conn
      end
    end

    def get(path, params = nil)
      connection.get(path) do |request|
        request.params = params if params
      end
    end

    def post(path, payload, params = nil)
      connection.post do |request|
        request.url path
        request.headers['Content-Type'] = 'application/xml'
        request.body = payload
        request.params if params
      end
    end

    def put(path, payload, params = nil)
      connection.put do |request|
        request.url path
        request.headers['Content-Type'] = 'application/xml'
        request.body = payload
        request.params if params
      end
    end

    def delete(path, params = nil)
      connection.delete(path)
    end

    def publish(path, params = nil)
      connection.post(path)
    end

    def refund(path, params = nil)
      connection.post(path)
    end
  end

  module ApiMethods
    def get(path, params = nil)
      raw = params && params.delete(:raw)
      response = super
      raw ? response.env[:raw_body] : response.body
    end

    def post(path, payload, params = nil)
      raw = params && params.delete(:raw)
      response = super
      raw ? response.env[:raw_body] : response.body
    end

    def put(path, payload, params = nil)
      raw = params && params.delete(:raw)
      response = super
      raw ? response.env[:raw_body] : response.body
    end

    def delete(path, params = nil)
      raw = params && params.delete(:raw)
      response = super
      raw ? response.env[:raw_body] : response.body
    end

    def publish(path, params = nil)
      raw = params && params.delete(:raw)
      response = super
      raw ? response.env[:raw_body] : response.body
    end

    def refund(path, params = nil)
      raw = params && params.delete(:raw)
      response = super
      raw ? response.env[:raw_body] : response.body
    end

    def market(market_id, *args)
      get("markets/#{market_id}.xml", *args)
    end

    def markets(*args)
      get("markets.json", *args)
    end

    def new_market(question, class_type, ends_at, tag_list)
      market_data = { :'name'       => question,
                      :'class-type' => class_type,
                      :'ends-at'    => ends_at,
                      :'tag-list'   => tag_list
      }
      post("markets.xml", market_data.to_xml(:root => "market"), :content_type => 'application/xml')
    end

    def update_market(market_id, question)
      market_data = { :'name' => question }
      put("markets/#{market_id}.xml", market_data.to_xml(:root => "market"), :content_type => 'application/xml')
    end

    def delete_market(market_id)
      delete("markets/#{market_id}.xml", :content_type => 'application/xml')
    end

    def publish_market(market_id)
      publish("markets/#{market_id}.xml", :content_type => 'application/xml')
    end

    def memberships(*args)
      get("memberships.xml", *args)
    end

    def membership(member_id, *args)
      get("memberships/#{member_id}.xml", *args)
    end

    def me # Get's membership of current logged in user
      get("memberships/me.xml")
    end

    def create_membership(login, email, password, first_name, last_name)
      membership_data = { :'login' => login,
                          :'password' => password,
                          :'email' => email,
                          :'first-name' => first_name,
                          :'last-name' => last_name
      }
      post("memberships.xml", membership_data.to_xml(:root => "membership"), :content_type => 'application/xml')
    end

    def update_membership(first_name, last_name, membership_id)
      membership_data = { :'first-name' => first_name, :'last-name' => last_name }
      put("memberships/#{membership_id}.xml", membership_data.to_xml(:root => "membership"), :content_type => 'application/xml')
    end

    def update_balance(balance_value, membership_id)
      balance_data = { :'value' => balance_value }
      put("memberships/#{membership_id}/balance.xml", balance_data.to_xml(:root => "balance"), :content_type => 'application/xml')
    end

    def delete_membership(membership_id)
      delete("memberships/#{membership_id}.xml", :content_type => 'application/xml')
    end

    def get_token_for(membership_id)
      get("memberships/#{membership_id}/tokens.xml")
    end

    def prices(*args)
      get("prices.xml", *args)
    end

    def positions
      get("positions.xml")
    end

    def create_answer(answer, symbol, market_id)
      answer_data = { :'name' => answer,
                      :'symbol' => symbol
      }
      post("markets/#{market_id}/stocks.xml", answer_data.to_xml(:root => "stock"), :content_type => 'application/xml')
    end

    def answer(stock_id)
      get("stocks/#{stock_id}.xml")
    end

    def update_answer(stock_id, answer, symbol, starting_price)
      answer_data = { :'name' => answer,
                      :'symbol' => symbol,
                      :'starting-price' => starting_price
      }
      put("stocks/#{stock_id}.xml", answer_data.to_xml(:root => "stock"), :content_type => 'application/xml')
    end

    def delete_answer(stock_id)
      delete("stocks/#{stock_id}.xml")
    end

    def cash_out(stock_id, price = 0)
      cash_out_data = { :'price' => price }
      post("stocks/#{stock_id}/resolutions.xml", cash_out_data.to_xml(:root => "resolution"), :content_type => 'application/xml')
    end

    def create_refund(stock_id)
      refund("stocks/#{stock_id}/refunds.xml")
    end

    def trades
      get("memberships/all/trades.xml")
    end

    def create_trade(stock_id, membership_id, quantity)
      trade_data = { :'quantity' => quantity,
                     :'membership_id' => membership_id
      }
      post("stocks/#{stock_id}/trades.xml", trade_data.to_xml(:root => "trade"), :content_type => 'application/xml')
    end

    def quote(stock_id, membership_id, quantity)
      quote_data = { :'quantity' => quantity,
                     :'membership_id' => membership_id
      }
      post("stocks/#{stock_id}/trades/quote.xml", quote_data.to_xml(:root => "trade"), :content_type => 'application/xml')
    end

  end

  extend Configuration
  extend Connection
  extend ApiMethods
end
