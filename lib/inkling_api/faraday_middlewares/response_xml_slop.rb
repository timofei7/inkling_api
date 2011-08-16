module FaradayMiddlewares
  class ResponseXMLSlop < ::FaradayStack::ResponseMiddleware
    dependency do
      require 'nokogiri'
      Nokogiri::Slop
    end

    define_parser do |body|
      Nokogiri::Slop body
    end
  end
end
