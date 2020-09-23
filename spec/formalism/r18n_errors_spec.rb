# frozen_string_literal: true

describe Formalism::R18nErrors do
	before do
		R18n.default_places = "#{__dir__}/r18n_errors/locales/"
		R18n.set 'en'
	end

	let(:base_form_class) do
		described_class = self.described_class

		Class.new(Formalism::Form) do
			include described_class

			private

			def execute; end
		end
	end

	let(:user_form_class) do
		Class.new(base_form_class) do
			field :name, String

			def initialize(*)
				@errors_key = :user

				super
			end

			private

			def validate
				add_error :name, :is_empty if name.to_s.empty?
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
		end
	end

	let(:permissions_form_class) do
		Class.new(base_form_class) do
			field :permissions, Array, of: String

			private

			def validate
				# add_error :permissions, :are_empty if permissions.empty?
			end
		end
	end

	let(:form_class) { user_form_class }

	let(:params) {}

	let(:form) { form_class.new(params) }

	describe '#add_error' do
		subject(:errors_translations) { form.run.errors.translations }

		context 'with `errors_key`' do
			it { is_expected.to eq ['User name is empty'] }
		end

		context 'without `errors_key`' do
			let(:form_class) do
				Class.new(base_form_class) do
					private

					def validate
						add_error :foo, :bar
					end
				end
			end

			it do
				expect { errors_translations }.to raise_error(RuntimeError, '`@errors_key` is required')
			end
		end
	end

	describe '`:errors_key` option for nested' do
		subject { form.run.errors.translations }

		before do
			geolocation_form_class = self.geolocation_form_class

			user_form_class.class_exec do
				nested :location, geolocation_form_class, errors_key: :geolocation
			end
		end

		it { is_expected.to eq ['User name is empty', 'Geolocation address is empty'] }
	end

	describe '#to_params' do
		subject { form.to_params }

		before do
			geolocation_form_class = self.geolocation_form_class
			permissions_form_class = self.permissions_form_class

			user_form_class.class_exec do
				nested :location, geolocation_form_class, errors_key: :geolocation

				nested :permissions, permissions_form_class, errors_key: nil
			end
		end

		let(:params) do
			{
				name: 'Alexander',
				location: { address: 'Moscow' },
				permissions: { permissions: %w[view_posts manage_users] }
			}
		end

		let(:expected_params) do
			{
				name: 'Alexander',
				location: { address: 'Moscow' },
				permissions: %w[view_posts manage_users]
			}
		end

		it { is_expected.to eq expected_params }
	end

	describe '#translations_hash' do
		subject { form.run.errors.translations_hash }

		before do
			geolocation_form_class = self.geolocation_form_class

			user_form_class.class_exec do
				nested :location, geolocation_form_class, errors_key: :geolocation
			end
		end

		let(:expected_hash) do
			{
				user: {
					name: {
						is_empty: 'User name is empty'
					},
					geolocation: {
						address: {
							is_empty: 'Geolocation address is empty'
						}
					}
				}
			}
		end

		it { is_expected.to eq expected_hash }
	end
end
