require 'uri'
require 'net/http'

module Mock
  class MockHTTP
    attr_reader :root, :headers, :params, :query, :cookies, :method

    def initialize(root_url, headers: {}, params: {}, query: {}, cookies: {})
      @root = root_url
      @headers = headers
      @params = params
      @query = query
      @cookies = cookies
    end

    def attributes
      {
        :query => @query.clone,
        :header => @header.clone, 
        :params => @params.clone,
        :cookies => @cookies.clone
      }
    end

    def response
      "This is final response #{@root} #{@header}"
    end

    def set_cookiee(*args)
      set_hash(@cookies, *args)
    end

    def set_header(*args)
      set_hash(@headers, *args)
    end

    def get(&block)
      @method = :get
      temp_instance = MockHTTP.new(@root, **attributes)
      temp_instance.instance_eval(&block)
    end

    private
      def set_hash(hash, key, value)
        hash[key] = value
      end

      def make_request
        uri = URI(@root)
        uri.query = URI.encode_www_form(@params)
      end
  end

  def self.url(root_url, &block)
    http = MockHTTP.new(root_url) 
    http.instance_eval(&block)
  end
end
