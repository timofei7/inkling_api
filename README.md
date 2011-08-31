InklingAPI
----------

To run the tests
================

create a file in lib/inkling_api_test_config.rb that looks like the following

    module InklingApiTestConfig
      class << self
        def url
          "http://url.inklingmarkets.com"
        end

        def login
          "some-login"
        end

        def password
          "some-password"
        end
      end
    end
