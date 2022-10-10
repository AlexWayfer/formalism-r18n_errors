# frozen_string_literal: true

require_relative 'lib/formalism/r18n_errors/version'

Gem::Specification.new do |spec|
	spec.name        = 'formalism-r18n_errors'
	spec.version     = Formalism::R18nErrors::VERSION
	spec.authors     = ['Alexander Popov']
	spec.email       = ['alex.wayfer@gmail.com']

	spec.summary     = 'Errors for Formalism via R18n'
	spec.description = <<~DESC
		Errors for Formalism via R18n.
	DESC
	spec.license = 'MIT'

	github_uri = "https://github.com/AlexWayfer/#{spec.name}"

	spec.homepage = github_uri

	spec.metadata = {
		'bug_tracker_uri' => "#{github_uri}/issues",
		'changelog_uri' => "#{github_uri}/blob/v#{spec.version}/CHANGELOG.md",
		'homepage_uri' => spec.homepage,
		'rubygems_mfa_required' => 'true',
		'source_code_uri' => github_uri
	}

	spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt', 'CHANGELOG.md']

	spec.required_ruby_version = '>= 2.6', '< 4'

	spec.add_runtime_dependency 'formalism', '~> 0.5.0'
	spec.add_runtime_dependency 'gorilla_patch', '>= 4.0', '< 6'
	spec.add_runtime_dependency 'r18n-core', '~> 5.0'

	spec.add_development_dependency 'email_address', '~> 0.2.4'
	spec.add_development_dependency 'net-smtp', '~> 0.3.1'
	spec.add_development_dependency 'sequel', '~> 5.60'
	spec.add_development_dependency 'uuid', '~> 2.0'

	spec.add_development_dependency 'pry-byebug', '~> 3.9'

	spec.add_development_dependency 'bundler', '~> 2.0'
	spec.add_development_dependency 'bundler-audit', '~> 0.9.1'

	spec.add_development_dependency 'gem_toys', '~> 0.12.1'
	spec.add_development_dependency 'toys', '~> 0.14.2'

	spec.add_development_dependency 'rspec', '~> 3.9'
	spec.add_development_dependency 'simplecov', '~> 0.21.0'
	spec.add_development_dependency 'simplecov-cobertura', '~> 2.1'

	spec.add_development_dependency 'rubocop', '~> 1.37.0'
	spec.add_development_dependency 'rubocop-performance', '~> 1.0'
	spec.add_development_dependency 'rubocop-rspec', '~> 2.2'
	spec.add_development_dependency 'rubocop-sequel', '~> 0.3.4'
end
