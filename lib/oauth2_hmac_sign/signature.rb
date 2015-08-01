require 'base64'
require 'openssl'
require 'securerandom'

# A single signature generator and validator Oauth2 HTTP MAC token.
# https://tools.ietf.org/html/rfc2616
module Oauth2HmacSign
  class Signature
    attr_reader :ts, :nonce, :method, :uri, :host, :port, :ext
    attr_reader :mac

    class << self

      # Generate oauth2 hmac signature with required and optional vars
      #
      # == Parameters:
      # algorithm::
      #   Name of the algorithm valid vars are hmac-sha256, hmac-sha1
      # key::
      #   Key for hmac algorithm
      # method::
      #   The HTTP request method in upper case.  For example: "HEAD", "GET", "POST", etc.
      # uri::
      #   The HTTP request-URI as defined by https://tools.ietf.org/html/rfc2616#section-5.1.2
      # host::
      #   The hostname included in the HTTP request using the "Host" request header field in lower case.
      # port::
      #   The port as included in the HTTP request using the "Host" request
      #   header field.  If the header field does not include a port, the
      #   default value for the scheme MUST be used (e.g. 80 for HTTP and
      #   443 for HTTPS).
      # ext:: 
      #   The value of the "ext" "Authorization" request header field
      #   attribute if one was included in the request, otherwise, an empty
      #   string.
      # 
      # == Returns:
      #   Returns the generated signature and required variables to verify it. 
      # ts::
      #   The timestamp value calculated for the signature.
      # nonce::
      #   The nonce value generated for the signature.
      # ext::
      #   The value of passed or assigned for ext
      # mac::
      #   The signature
      #
      def generate(algorithm, key, method, uri, host, port = 443, ext = '')
        @ts = Time.now.to_i
        @nonce = generate_nonce
        @method = method
        @uri = uri
        @host = host
        @port = port
        @ext = ext
        @mac = calculate(
          algorithm_constructor(algorithm),
          key,
          normalized_request_string
        )
        return @ts, @nonce, @ext, @mac
      end
      
      # Validate oauth2 hmac signature with required and optional vars
      #
      # == Parameters:
      # mac::
      #   Signature for validation
      # algorithm::
      #   Name of the algorithm valid vars are hmac-sha256, hmac-sha1
      # key::
      #   Key for hmac algorithm
      # ts::
      #   The timestamp value calculated for the request.
      # nonce::
      #   The nonce value generated for the request.
      # method::
      #   The HTTP request method in upper case.  For example: "HEAD", "GET", "POST", etc.
      # uri::
      #   The HTTP request-URI as defined by https://tools.ietf.org/html/rfc2616#section-5.1.2
      # host::
      #   The hostname included in the HTTP request using the "Host" request header field in lower case.
      # port::
      #   The port as included in the HTTP request using the "Host" request
      #   header field.  If the header field does not include a port, the
      #   default value for the scheme MUST be used (e.g. 80 for HTTP and
      #   443 for HTTPS).
      # ext:: 
      #   The value of the "ext" "Authorization" request header field
      #   attribute if one was included in the request, otherwise, an empty
      #   string.
      # 
      # == Returns:
      # Boolean: true for succesfully verified mac signature and false for invalid mac signature
      #
      def is_valid?(mac, algorithm, key, ts, nonce, method, uri, host, port, ext)
        @ts = ts
        @nonce = nonce
        @method = method
        @uri = uri
        @host = host
        @port = port
        @ext = ext
        mac.eql?(calculate(
            algorithm_constructor(algorithm),
            key,
            normalized_request_string
          )
        )
      end

      private
      # nodoc
      def calculate(algorithm, key, text)
        Base64.urlsafe_encode64(
          OpenSSL::HMAC.digest(
            algorithm,
            key,
            text
          )
        )
      end

      # nodoc
      def generate_nonce
        "#{@ts}:#{SecureRandom.hex(4)}"
      end

      # nodoc      
      # https://tools.ietf.org/html/draft-ietf-oauth-v2-http-mac-01#section-3.2.1
      def normalized_request_string
        "#{@ts}\n#{@nonce}\n#{@method.to_s.upcase}\n#{@uri}\n#{@host.to_s.downcase}\n#{@port}\n#{@ext}\n"
      end

      # nodoc
      def algorithm_constructor(algorithm)
        case algorithm
        when 'hmac-sha-256'
          OpenSSL::Digest::SHA256.new
        when 'hmac-sha-1'
          OpenSSL::Digest::SHA1.new
        else
          raise 'Unregistered algorithm!'
        end
      end
    end
  end
end