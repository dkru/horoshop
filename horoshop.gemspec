# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'horoshop'
  s.version     = '0.2.0'
  s.summary     = 'Horoshop API interface'
  s.description = 'Gem for exchangedata with the internet shop constructor'
  s.authors     = ['Denys Krupenov', 'Illiya Bordun']
  s.email       = 'dkru84@gmail.com'
  s.files = Dir['lib/**/*', 'LICENSE', 'README.md']
  s.require_paths = 'lib'
  s.homepage    = 'https://github.com/dkru/horoshop'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.6.1'

  s.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
