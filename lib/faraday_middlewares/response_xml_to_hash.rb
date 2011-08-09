module FaradayMiddlewares
  class ResponseXMLToHash < ::FaradayStack::ResponseMiddleware
    dependency do
      require 'active_support/core_ext'
      Hash
    end

    define_parser do |body|
      Hash.from_xml body
    end
  end
end
