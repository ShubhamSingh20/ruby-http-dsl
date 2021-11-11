require 'uri'
require 'json'
require 'net/http'

require_relative 'utils'

module Mock
  class MockHTTP
    class << self
      MOCK_ATTRIBUTES = {
        :root => nil, :method => nil, :headers => {}, 
        :params => {}, :query => {}, :cookies => {}, :body => {}
      }

      def define_initialize
        define_method(:initialize) do |**kwargs|
          MOCK_ATTRIBUTES.each do |attribute, default_value|
            # either get the value passed by the user or get the default value from `MOCK_ATTRIBUTES`
            instance_variable_set("@#{attribute}", kwargs[attribute] || default_value)
          end
        end
      end

      def define_attributes
        define_method(:attributes) do
          MOCK_ATTRIBUTES.keys.reduce({}) do |acc, attribute| 
            acc.merge({attribute => instance_variable_get("@#{attribute.to_s}").clone})
          end
        end
      end

      def define_attribute_setters
        [:headers, :params, :query, :cookies].each do |attribute|
          define_method("set_#{attribute.to_s}") do |key, value|
            attribute_value = instance_variable_get("@#{attribute.to_s}")
            attribute_value[key] = value.to_s
          end
        end

        define_method(:set_body) do |body|
          instance_variable_set(:@body, body)
        end
      end

      def define_http_actions
        [:get, :post, :delete].each do |action|
          define_method("#{action.to_s}") do |url, &block|
            instance_variable_set(:@root, url)
            instance_variable_set(:@method, action)
            nested_instance(&block)
          end
        end
      end
    end

    def uri_with_params
      uri = @root.dup
      @params.each { |sym, v| uri.gsub! "{#{sym.to_s}}", v.to_s}
      uri
    end

    def response
      make_request
    end

    def json
      response = make_request()
      JSON.parse(response.body) if response.code.to_i < 500
    end

    private
      def nested_instance(&block)
        temp_instance = MockHTTP.new(root: @root, **attributes)
        temp_instance.instance_eval(&block)
      end

      def append_headers(request)
        # set headers
        @headers.each { |h, v| request[h.to_s] = v}

        unless @cookies.empty?
          request['Cookie'] = @cookies.keys.map(&:to_s)
            .zip(@cookies.values.map(&:to_s))
            .map { |r| r.join "=" }
            .join ";"
        end

        request
      end

      def make_request
        uri = URI(uri_with_params)
        uri.query = URI.encode_www_form(@query) unless @query.empty?

        http_class = Utils.class_from_string("Net::HTTP::#{@method.to_s.capitalize}")
        request = http_class.new(uri)
        request = append_headers(request)

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http|
          http.request(request)
        }
      end
  end

  def self.http(&block)
    http = MockHTTP.new 
    http.instance_eval(&block)
  end

  MockHTTP.define_initialize
  MockHTTP.define_attributes
  MockHTTP.define_http_actions
  MockHTTP.define_attribute_setters
end
