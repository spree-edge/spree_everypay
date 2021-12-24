# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_everypay/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_everypay'
  s.version     = SpreeEverypay.version
  s.summary     = 'Everypay payment gateway'
  s.description = 'Everypay payment gateway with spree support'
  s.required_ruby_version = '>= 2.5'

  s.author    = 'Rahul Singh'
  s.email     = 'rahul@bluebash.co'
  s.homepage  = 'https://github.com/rahul-bluebash/spree_everypay'
  s.license = 'BSD-3-Clause'

  s.files       = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree', '>= 4.3.0'
  # s.add_dependency 'spree_backend' # uncomment to include Admin Panel changes
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'spree_dev_tools'
end
