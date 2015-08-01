# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oauth2_hmac_sign/version'

Gem::Specification.new do |spec|
  spec.name          = "oauth2_hmac_sign"
  spec.version       = Oauth2HmacSign::VERSION
  spec.authors       = ["Mustafa TURAN"]
  spec.email         = ["mustafaturan.net@gmail.com"]

  spec.summary       = %q{A single signature generator and validator Oauth v2 HTTP MAC authentication.}
  spec.description   = %q{Generate and verify signatures for oauth v2 http mac authentication}
  spec.homepage      = "https://github.com/mustafaturan/oauth2_hmac_sign"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end