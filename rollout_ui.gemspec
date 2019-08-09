# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'rollout_ui/version'

Gem::Specification.new do |gem|
  gem.name          = 'rollout_ui'
  gem.version       = RolloutUi::VERSION
  gem.authors       = ['TRX Development Team', 'John Allison']
  gem.email         = ['developers@trx.tv', 'jrallison@gmail.com']
  gem.description   = <<~TEXT
    A UI for James Golick's rollout gem, forked
    from the original at https://github.com/jrallison/rollout_ui
  TEXT
  gem.summary       = "A UI for James Golick's rollout gem"
  gem.homepage      = 'http://github.com/rightsxchange/rollout_ui'

  gem.files         = Dir['lib/**/*'] + ['Rakefile', 'README.markdown']
  gem.test_files    = Dir['spec/**/*']
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'rollout'

  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'launchy'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'rails', '~> 4.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'redis-namespace'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'sinatra'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'uglifier'
end
