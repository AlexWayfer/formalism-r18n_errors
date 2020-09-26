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

	spec.required_ruby_version = '~> 2.6'

	source_code_uri = 'https://github.com/AlexWayfer/formalism-r18n_errors'

	spec.homepage = source_code_uri

	spec.metadata['source_code_uri'] = source_code_uri

	spec.metadata['homepage_uri'] = spec.homepage

	spec.metadata['changelog_uri'] =
		'https://github.com/AlexWayfer/formalism-r18n_errors/blob/master/CHANGELOG.md'

	spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt', 'CHANGELOG.md']

	spec.add_runtime_dependency 'formalism', '~> 0.2.0'
	spec.add_runtime_dependency 'gorilla_patch', '~> 4.0'
	spec.add_runtime_dependency 'r18n-core', '~> 4.0'

	spec.add_development_dependency 'pry-byebug', '~> 3.9'

	spec.add_development_dependency 'bundler', '~> 2.0'
	spec.add_development_dependency 'gem_toys', '~> 0.4.0'
	spec.add_development_dependency 'toys', '~> 0.11.0'

	spec.add_development_dependency 'codecov', '~> 0.2.0'
	spec.add_development_dependency 'rspec', '~> 3.9'
	spec.add_development_dependency 'simplecov', '~> 0.19.0'

	spec.add_development_dependency 'rubocop', '~> 0.91.0'
	spec.add_development_dependency 'rubocop-performance', '~> 1.0'
	spec.add_development_dependency 'rubocop-rspec', '~> 1.0'
end
