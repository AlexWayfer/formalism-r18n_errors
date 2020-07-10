# frozen_string_literal: true

require 'formalism'

require_relative 'r18n_errors/version'
require_relative 'r18n_errors/errors'

module Formalism
	## Main module which should be included into base form
	module R18nErrors
		def initialize(*)
			## `@errors_key` should be set in using form
			@errors = Errors.new

			super
		end

		protected

		attr_accessor :errors_key
		attr_reader :errors

		private

		def initialize_nested_form(name, options)
			return unless (form = super)

			form.errors_key = options.fetch(:errors_key, name)
			form
		end

		def add_error(*args, **kwargs)
			raise '`@errors_key` is required' unless errors_key

			errors.add errors_key, *args, **kwargs
		end

		def merge_errors_of_nested_form(name, nested_form)
			add_error name, nested_errors: nested_form.errors
		end

		def nested_form_to_params(_name_of_nested_form, nested_form)
			return super if nested_form.errors_key

			nested_form.to_params
		end
	end
end
