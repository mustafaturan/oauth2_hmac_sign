require 'spec_helper'

describe Oauth2HmacSign::Signature do
  before(:all) do
    @algorithm = 'hmac-sha-256'
    @key = 'demo_key'
    @method = 'post'
    @uri = '/request?b5=%3D%253D&a3=a&c%40=&a2=r%20b&c2&a3=2+q'
    @host = 'example.com'
    @port = 443
    @ext = 'a,b,c'
    @ts, @nonce, @ext, @mac  = Oauth2HmacSign::Signature.generate(
      @algorithm, @key, @method, @uri, @host, @port, @ext
    )
  end

  describe '.generate' do
    it 'generates unique oauth mac signature' do
      ts2, nonce2, ext2, mac2 = Oauth2HmacSign::Signature.generate(
        @algorithm, @key, @method, @uri, @host, @port, @ext
      )
      expect(@mac).not_to eq(mac2)
    end
  end

  describe '.is_valid?' do
    it 'check if the oauth mac signature is valid for the given parameters' do
      expect(Oauth2HmacSign::Signature.is_valid?(
          @mac,
          @algorithm,
          @key,
          @ts,
          @nonce,
          @method,
          @uri,
          @host,
          @port,
          @ext
        )
      ).to eq(true)
    end
  end
end