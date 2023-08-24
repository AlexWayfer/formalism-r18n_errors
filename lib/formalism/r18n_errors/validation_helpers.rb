# frozen_string_literal: true

require 'gorilla_patch/blank'

module Formalism
	module R18nErrors
		## Helper methods for validations
		module ValidationHelpers
			private

			using GorillaPatch::Blank

			def validate_provision(*validation_fields, error_key: :not_provided)
				valid = true
				validation_fields.flatten.each do |validation_field|
					next unless field_changed?(validation_field)
					next if field_valid?(validation_field)

					valid = false
					add_error validation_field, error_key
				end
				valid
			end

			def validate_entry(*validation_fields)
				validate_provision(*validation_fields, error_key: :not_entered)
			end

			def validate_choice(*validation_fields)
				validate_provision(*validation_fields, error_key: :not_chosen)
			end

			def validate_max_length(validation_field, max_length)
				return unless field_changed?(validation_field)

				value = public_send(validation_field)
				return true if value && value.length <= max_length

				add_error validation_field, :greater_than, args: max_length
				false
			end

			def validate_min_length(validation_field, min_length)
				return unless field_changed?(validation_field)

				value = public_send(validation_field)
				return true if value && value.length >= min_length

				add_error validation_field, :less_than, args: min_length
				false
			end

			def validate_range_entry(validation_field, range)
				return unless field_changed?(validation_field)

				value = public_send(validation_field).to_f

				add_error validation_field, :less_than, args: range.begin if value < range.begin

				return unless range.end
				return if value.public_send (range.exclude_end? ? :< : :<=), range.end

				add_error validation_field, :greater_than, args: range.end
			end

			## Requires `email_address` gem
			def validate_email(*validation_fields)
				valid = true
				validation_fields.flatten.each do |validation_field|
					next unless field_changed?(validation_field)
					next if EmailAddress.valid? public_send(validation_field)

					valid = false
					add_error validation_field, :not_valid_email
				end
				valid
			end

			def validate_uuid(*validation_fields)
				valid = true
				validation_fields.flatten.each do |validation_field|
					next unless field_changed?(validation_field)
					next if /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/.match? public_send(validation_field)

					valid = false
					add_error validation_field, :not_valid_uuid
				end
				valid
			end

			## Requires `formalism-model_form` gem
			def validate_uniqueness(*fields_combinations)
				valid = true
				fields_combinations.each do |*fields_combination|
					fields_combination.flatten!

					next if fields_combination.none? { |field| field_changed?(field) }

					next if unique_by_fields_combination? fields_combination

					valid = false
					add_error_for_uniqueness_validation fields_combination
				end
				valid
			end

			## Private methods for this module

			def field_valid?(field)
				result = true
				if (nested_form = nested_forms[field])
					result = nested_form.valid?
					return result unless result

					nested_form.run
				end
				result && !public_send(field).blank?
			end

			def unique_by_fields_combination?(fields_combination)
				dataset = model.where(
					fields_combination
						.map { |field| field_condition(field, send(field)) }
						.reduce(:&)
				)
				dataset = dataset.exclude(instance.pk_hash) if instance&.pk_hash
				dataset.empty?
			end

			def add_error_for_uniqueness_validation(fields)
				if fields.count == 1
					add_error fields.first, :already_taken
				else
					add_error :itself, :already_exists, fields.join('_and_')
				end
			end

			def field_changed?(_field)
				true ## can be redefined, for example, in update forms
			end
		end
	end
end
