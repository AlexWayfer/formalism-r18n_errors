# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'email_address', '~> 0.2.8'
gem 'net-smtp', '>= 0.4', '<= 0.6'
gem 'sequel', '~> 5.60'

group :development do
	gem 'pry-byebug', '~> 3.9'

	gem 'gem_toys', '~> 1.0'
	gem 'toys', '~> 0.19.0'
end

group :lint do
	gem 'rubocop', '~> 1.84.2'
	gem 'rubocop-performance', '~> 1.26.0'
	gem 'rubocop-rspec', '~> 3.9.0'
	gem 'rubocop-sequel', '~> 0.4.0'
end

group :test do
	gem 'rspec', '~> 3.9'
	gem 'simplecov', '~> 0.22.0'
	gem 'simplecov-cobertura', '~> 3.0'
end

group :audit do
	gem 'bundler-audit', '~> 0.9.1'
end
