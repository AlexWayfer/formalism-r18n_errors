# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'email_address', '~> 0.2.4'
gem 'net-smtp', '~> 0.4.0'
gem 'sequel', '~> 5.60'

group :development do
	gem 'pry-byebug', '~> 3.9'

	gem 'bundler', '~> 2.0'

	gem 'gem_toys', '~> 0.14.0'
	gem 'toys', '~> 0.15.0'
end

group :lint do
	gem 'rubocop', '~> 1.61.0'
	gem 'rubocop-performance', '~> 1.0'
	gem 'rubocop-rspec', '~> 2.26.1'
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
