# frozen_string_literal: true

require_relative '../../../lib/formalism/r18n_errors/validation_helpers'

describe Formalism::R18nErrors::ValidationHelpers do
	subject { form.run.errors.translations }

	before do
		R18n.default_places = "#{__dir__}/locales/"
		R18n.set 'en'
	end

	let(:base_form_class) do
		described_class = self.described_class

		Class.new(Formalism::Form) do
			include Formalism::R18nErrors
			include described_class

			private

			def execute; end
		end
	end

	let(:user_form_class) do
		geolocation_form_class = self.geolocation_form_class

		Class.new(base_form_class) do
			field :name, String
			field :country
			field :city
			field :score, Float

			nested :location, geolocation_form_class, merge_errors: false

			def initialize(*)
				@errors_key = :user

				super
			end
		end
	end

	let(:geolocation_form_class) do
		Class.new(base_form_class) do
			field :address, String

			private

			def validate
				add_error :address, :is_empty if address.to_s.empty?
			end

			def execute
				@instance = :object
			end
		end
	end

	let(:form_class) { user_form_class }

	let(:params) { nil }

	let(:user_name) { 'Alexander' }
	let(:user_city) { 'Moscow' }
	let(:user_country) { 'Russia' }

	let(:non_empty_params) do
		{
			name: user_name,
			city: user_city,
			country: user_country,
			location: {
				address: 'Foo Bar'
			}
		}
	end

	let(:form) { form_class.new(params) }

	describe '#validate_provision' do
		before do
			user_form_class.class_exec do
				private

				def validate
					validate_provision :name
					validate_provision %i[country city]
					validate_provision :location
				end
			end
		end

		context 'when params are empty' do
			let(:expected_errors) do
				[
					'User name not provided',
					'User country not provided',
					'User city not provided',
					'User location not provided'
				]
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when params are not empty' do
			let(:params) { non_empty_params }

			it { is_expected.to be_empty }
		end
	end

	describe '#validate_entry' do
		before do
			user_form_class.class_exec do
				private

				def validate
					validate_entry :name
					validate_entry %i[country city]
					validate_entry :location
				end
			end
		end

		context 'when params are empty' do
			let(:expected_errors) do
				[
					'User name not entered',
					'User country not entered',
					'User city not entered',
					'User location not entered'
				]
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when params are not empty' do
			let(:params) { non_empty_params }

			it { is_expected.to be_empty }
		end
	end

	describe '#validate_choice' do
		before do
			user_form_class.class_exec do
				private

				def validate
					validate_choice :name
					validate_choice %i[country city]
					validate_choice :location
				end
			end
		end

		context 'when params are empty' do
			let(:expected_errors) do
				[
					'User name not chosen',
					'User country not chosen',
					'User city not chosen',
					'User location not chosen'
				]
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when params are not empty' do
			let(:params) { non_empty_params }

			it { is_expected.to be_empty }
		end
	end

	describe '#validate_max_length' do
		before do
			user_form_class.class_exec do
				private

				def validate
					validate_max_length :name, 5
				end
			end
		end

		let(:params) { non_empty_params }

		context 'when name does not fit' do
			let(:user_name) { 'Alexander' }

			let(:expected_errors) do
				['User name greater than 5 characters']
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when name fits' do
			let(:user_name) { 'Alex' }

			it { is_expected.to be_empty }
		end
	end

	describe '#validate_min_length' do
		before do
			user_form_class.class_exec do
				private

				def validate
					validate_min_length :name, 5
				end
			end
		end

		let(:params) { non_empty_params }

		context 'when name shorten than required' do
			let(:user_name) { 'Alex' }

			let(:expected_errors) do
				['User name less than 5 characters']
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when name longer than required' do
			let(:user_name) { 'Alexander' }

			it { is_expected.to be_empty }
		end
	end

	describe '#validate_range_entry' do
		before do
			user_form_class.class_exec(score_range) do |score_range|
				private

				define_method :validate do
					validate_range_entry :score, score_range
				end
			end
		end

		let(:score_range) { 1..5 }
		let(:params) { non_empty_params }
		let(:non_empty_params) { super().merge(score: score) }

		context 'when score less than range' do
			let(:score) { 0.5 }

			let(:expected_errors) do
				['User score less than 1']
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when score greater than range' do
			let(:score) { 5.2 }

			let(:expected_errors) do
				['User score greater than 5']
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when score fits in range' do
			let(:score) { 4.8 }

			it { is_expected.to be_empty }
		end

		context 'when range is endless' do
			let(:score_range) { (1..) }
			let(:score) { 999 }

			it { is_expected.to be_empty }
		end
	end

	describe '#validate_email' do
		before do
			require 'email_address'

			user_form_class.class_exec do
				field :email, String
				field :secondary_email, String
				field :backup_email, String

				private

				def validate
					validate_email :email
					validate_email %i[secondary_email backup_email]
				end
			end
		end

		let(:expected_errors) do
			[
				'User email is not valid',
				'User secondary email is not valid',
				'User backup email is not valid'
			]
		end

		context 'when params are empty' do
			it { is_expected.to eq expected_errors }
		end

		context 'when params are not empty' do
			let(:params) { non_empty_params }
			let(:non_empty_params) do
				super().merge(email: user_email, secondary_email: user_email, backup_email: user_email)
			end

			context 'when email is not valid' do
				let(:user_email) { 'alexwayfer.name' }

				it { is_expected.to eq expected_errors }
			end

			context 'when email is valid' do
				let(:user_email) { 'alex.wayfer@gmail.com' }

				it { is_expected.to be_empty }
			end
		end
	end

	describe '#validate_uuid' do
		before do
			require 'uuid'

			user_form_class.class_exec do
				field :key, String
				field :another_key, String
				field :secret_key, String

				private

				def validate
					validate_uuid :key
					validate_uuid %i[another_key secret_key]
				end
			end
		end

		let(:expected_errors) do
			[
				'User key is not valid',
				'User another key is not valid',
				'User secret key is not valid'
			]
		end

		context 'when params are empty' do
			it { is_expected.to eq expected_errors }
		end

		context 'when params are not empty' do
			let(:params) { non_empty_params }
			let(:non_empty_params) do
				super().merge(key: user_key, another_key: user_key, secret_key: user_key)
			end

			context 'when email is not valid' do
				let(:user_key) { 'foo-bar' }

				it { is_expected.to eq expected_errors }
			end

			context 'when email is valid' do
				let(:user_key) { '123e4567-e89b-12d3-a456-426655440000' }

				it { is_expected.to be_empty }
			end
		end
	end

	describe '#validate_uniqueness' do
		before do
			user_form_class.class_exec do
				private

				def validate
					validate_uniqueness :name
					validate_uniqueness %i[city country]
				end
			end

			allow(form).to receive(:model).and_return form_model

			form_instance = instance_double('instance')

			allow(form_instance).to receive(:pk_hash).and_return(id: 42)

			allow(form).to receive(:instance).and_return form_instance

			allow(form).to receive(:field_condition) do |name, value|
				field_condition_class.new(name => value)
			end

			allow(form_model).to receive(:where)
				.with(field_condition_class.new(name: user_name))
				.and_return name_dataset_double

			allow(form_model).to receive(:where)
				.with(field_condition_class.new(city: user_city, country: user_country))
				.and_return city_and_country_dataset_double

			allow(name_dataset_double).to receive(:exclude).with(id: 42)
				.and_return(name_dataset_double)
			allow(city_and_country_dataset_double).to receive(:exclude).with(id: 42)
				.and_return(city_and_country_dataset_double)
		end

		let(:field_condition_class) do
			Class.new do
				attr_reader :condition

				def initialize(condition)
					@condition = condition
				end

				def ==(other)
					condition == other.condition
				end

				def &(other)
					self.class.new condition.merge other.condition
				end
			end
		end

		let(:form_model) { class_double('Sequel::Model') }
		let(:name_dataset_double) { instance_double('dataset') }
		let(:city_and_country_dataset_double) { instance_double('dataset') }

		let(:params) { non_empty_params }

		context 'when user name is not unique' do
			before do
				allow(name_dataset_double).to receive(:empty?).and_return false
				allow(city_and_country_dataset_double).to receive(:empty?).and_return true
			end

			let(:expected_errors) do
				['This user name already taken']
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when user city and country is not unique' do
			before do
				allow(name_dataset_double).to receive(:empty?).and_return true
				allow(city_and_country_dataset_double).to receive(:empty?).and_return false
			end

			let(:expected_errors) do
				['User with these city and country already exists']
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when user is not unique' do
			before do
				allow(name_dataset_double).to receive(:empty?).and_return false
				allow(city_and_country_dataset_double).to receive(:empty?).and_return false
			end

			let(:expected_errors) do
				['This user name already taken', 'User with these city and country already exists']
			end

			it { is_expected.to eq expected_errors }
		end

		context 'when user is unique' do
			before do
				allow(name_dataset_double).to receive(:empty?).and_return true
				allow(city_and_country_dataset_double).to receive(:empty?).and_return true
			end

			it { is_expected.to be_empty }
		end
	end
end
