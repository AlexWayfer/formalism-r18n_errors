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

	spec.required_ruby_version = '>= 3.2', '< 5'

	spec.add_dependency 'formalism', '~> 1.0'
	spec.add_dependency 'gorilla_patch', '~> 6.0'
	spec.add_dependency 'r18n-core', '~> 6.0'
end
