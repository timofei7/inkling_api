require 'active_support'
# Apparently ActiveSupport moved some stuff around and FaradayStack is not wise to it
unless defined?(ActiveSupport::JSON::Backends::Yaml::DATE_REGEX)
  module ActiveSupport::JSON
    module Backends
      module Yaml
        DATE_REGEX = ::ActiveSupport::JSON::DATE_REGEX
      end
    end
  end
end
