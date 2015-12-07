# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'torrent-finder/version'

Gem::Specification.new do |spec|
  spec.name          = "torrent-finder"
  spec.version       = TorrentFinder::VERSION
  spec.authors       = ["Francis Chong", "Fredrik Bränström"]
  spec.email         = ["francis@ignition.hk", "branstrom@gmail.com"]
  spec.summary       = %q{Extensible command line tool to search torrent.}
  spec.homepage      = "https://github.com/semikolon/torrent-finder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "mechanize"
  spec.add_dependency "claide"
  spec.add_dependency "nokogiri"
  spec.add_dependency "httparty"
end
