# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

## https://github.com/afair/email_address/pull/98
gem 'email_address', github: 'AlexWayfer/email_address', branch: 'add_ruby_3.4_support'
gem 'net-smtp', '>= 0.4', '<= 0.6'
gem 'sequel', '~> 5.60'

group :development do
	gem 'pry-byebug', '~> 3.9'

	gem 'bundler', '~> 2.0'

	gem 'gem_toys', '~> 0.14.0'
	gem 'toys', '~> 0.15.0'
end

group :lint do
	gem 'rubocop', '~> 1.81.1'
	gem 'rubocop-performance', '~> 1.0'
	gem 'rubocop-rspec', '~> 3.3.0'
	gem 'rubocop-sequel', '~> 0.3.4'
end

group :test do
	gem 'rspec', '~> 3.9'
	gem 'simplecov', '~> 0.22.0'
	gem 'simplecov-cobertura', '~> 2.1'
end

group :audit do
	gem 'bundler-audit', '~> 0.9.1'
end
