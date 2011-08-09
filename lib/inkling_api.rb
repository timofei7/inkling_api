require 'faraday_stack'
require 'faraday_middlewares'
require 'hashie/mash'
require 'activesupport_yaml_hack'

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
          b.use FaradayStack::ResponseJSON, content_type: 'application/json'
          b.use FaradayMiddlewares::ResponseXMLToHash, content_type: 'application/xml'
          b.use PreserveRawBody
          #b.use FaradayStack::Caching, cache, strip_params: %w[access_token client_id] unless cache.nil?
          b.response :raise_error
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
  end

  module ApiMethods
    def get(path, params = nil)
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
  end

  extend Configuration
  extend Connection
  extend ApiMethods
end
