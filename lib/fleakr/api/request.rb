module Fleakr
  module Api # :nodoc:
    class Request

      # Generic catch-all exception for any API errors
      class ApiError < StandardError; end

      # Makes a request to the Flickr API and returns a valid Response object.  If
      # there are errors on the response it will rais an ApiError exception
      def self.with_response!(method, additional_parameters = {})
        request = Request.new(method, additional_parameters)
        response = request.send

        raise(ApiError, "Code: #{response.error.code} - #{response.error.message}") if response.error?

        response
      end

      # Create a new request for the specified API method and pass along any additional
      # parameters.  The Flickr API uses namespacing for its methods - this is optional
      # when calling this method.
      #
      # This must be called after initializing the library with the required API key
      # see (#Fleakr.api_key=)
      def initialize(method, additional_parameters = {})
        method = method.sub(/^(flickr\.)?/, 'flickr.')

        default_parameters = {:api_key => Fleakr.api_key, :method => method}
        @parameters = default_parameters.merge(additional_parameters)
      end

      private
      def endpoint_uri
        uri = URI.parse('http://api.flickr.com/services/rest/')
        uri.query = self.query_parameters
        uri
      end

      def query_parameters
        @parameters.map {|key,value| "#{key}=#{CGI.escape(value)}" }.join('&')
      end

      def send
        Response.new(Net::HTTP.get(self.endpoint_uri))
      end

    end
  end
end