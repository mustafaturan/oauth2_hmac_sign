# Oauth2HmacSign
[![Build Status](https://travis-ci.org/mustafaturan/oauth2_hmac_sign.png)](https://travis-ci.org/mustafaturan/oauth2_hmac_sign) [![Code Climate](https://codeclimate.com/github/mustafaturan/oauth2_hmac_sign.png)](https://codeclimate.com/github/mustafaturan/oauth2_hmac_sign)

A single signature generator and validator Oauth v2 HTTP message authentication code(MAC) authentication. It simply generates and verify signatures for Oauth v2 HTTP MAC authentication for 'SHA1' and 'SHA256' algorithms. Please visit https://tools.ietf.org/html/draft-ietf-oauth-v2-http-mac-01 for spec specifications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oauth2_hmac_sign'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oauth2_hmac_sign

## Usage

### For generating
```ruby
    algorithm = 'hmac-sha-256' # 'hmac-sha-256' or 'hmac-sha-1'
    key = 'demo_key' # your key
    method = 'post' # http method for request -> get, post, head, patch, ...
    uri = '/request?b5=%3D%253D&a3=a&c%40=&a2=r%20b&c2&a3=2+q' # request uri
    host = 'example.com' # server host name
    port = 443 # default is 443
    ext = 'a,b,c' # can be nil
    ts, nonce, ext, mac  = Oauth2HmacSign::Signature.generate(
      algorithm, key, method, uri, host, port, ext
    )
       
    # returns multiple information
    # ts = timestamp
    # nonce = unique string
    # ext = if nil send as input than returns empty string else returns the same string as input
    # mac = mac signature for the given parameters
```

### For verifying
```ruby
    Oauth2HmacSign::Signature.is_valid?(
      mac,
      algorithm,
      key,
      ts,
      nonce,
      method,
      uri,
      host,
      port,
      ext
    )

    # returns 
    # true for valid
    # false for invalid
```
## Contributing

1. Fork it ( https://github.com/mustafaturan/oauth2_hmac_sign/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
