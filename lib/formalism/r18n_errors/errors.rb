# frozen_string_literal: true

require 'r18n-core'

module Formalism
	module R18nErrors
		## Class for errors collection
		class Errors
			extend Forwardable

			def_delegators :@hash, :any?, :empty?, :clear, :to_json

			include R18n::Helpers

			## class for translation hash creation
			class ErrorTranslator
				def initialize(translations, form_errors)
					@translations = translations
					@form_errors = form_errors
					@result = Hash.new { |hsh, key| hsh[key] = Hash.new(&hsh.default_proc) }
				end

				def translate(prefixes)
					@form_errors.each do |model_key, errors|
						errors.each do |error|
							if error[:rest_keys]
								insert_translation_in_result(error, model_key, prefixes)
							else
								merge_nested_translations_with_result(error, prefixes)
							end
						end
					end
					@result
				end

				private

				def insert_translation_in_result(error, model_key, prefixes)
					translation_keys = error[:rest_keys][0..-2].unshift(model_key)
					edge_key = error[:rest_keys].last
					args = error[:translation_args]

					@result.dig(*translation_keys)[edge_key] =
						@translations.dig(*prefixes + translation_keys)[edge_key, args]
				end

				def merge_nested_translations_with_result(error, prefixes)
					nested_hash = error[:nested_errors].translations_hash(*prefixes)
					nested_hash = nested_hash[nil] while nested_hash.key?(nil)
					@result.merge! nested_hash
				end
			end

			private_constant :ErrorTranslator

			def initialize
				@hash = Hash.new do |hash, model|
					hash[model] = Hash.new do |model_hash, field|
						model_hash[field] = []
					end
				end
			end

			def add(model_key, field_key, *rest_keys, args: nil, nested_errors: nil)
				@hash[model_key][field_key].push(
					if nested_errors
						{ nested_errors: nested_errors }
					else
						{ rest_keys: rest_keys, translation_args: args }
					end
				)
			end

			def translations(*prefixes)
				@hash.flat_map do |model_key, field_hash|
					field_hash.flat_map do |field_key, errors_array|
						errors_array.flat_map do |error|
							translate prefixes, model_key, field_key, error
						end
					end
				end
			end

			def translations_hash(*prefixes)
				prefixes.push(@hash.keys.first) if @hash.keys.first
				@hash.transform_values do |errors|
					ErrorTranslator.new(t.error, errors).translate(prefixes)
				end
			end

			private

			def translate(prefixes, model_key, field_key, error)
				if (nested_errors = error[:nested_errors])
					return nested_errors.translations(*prefixes, model_key)
				end

				rest_keys = error.fetch(:rest_keys)
				t.error
					.dig(*[*prefixes, model_key, field_key].compact, *rest_keys[0..-2])
					.public_send(rest_keys.last, error[:translation_args])
			end
		end

		private_constant :Errors
	end
end
