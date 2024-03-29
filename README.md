# Formalism R18n Errors

[![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/AlexWayfer/formalism-r18n_errors?style=flat-square)](https://cirrus-ci.com/github/AlexWayfer/formalism-r18n_errors)
[![Codecov branch](https://img.shields.io/codecov/c/github/AlexWayfer/formalism-r18n_errors/main.svg?style=flat-square)](https://codecov.io/gh/AlexWayfer/formalism-r18n_errors)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/AlexWayfer/formalism-r18n_errors.svg?style=flat-square)](https://codeclimate.com/github/AlexWayfer/formalism-r18n_errors)
[![Inline docs](https://inch-ci.org/github/AlexWayfer/formalism-r18n_errors.svg?branch=main)](https://inch-ci.org/github/AlexWayfer/formalism-r18n_errors)
[![license](https://img.shields.io/github/license/AlexWayfer/formalism-r18n_errors.svg?style=flat-square)](LICENSE.txt)
[![Gem](https://img.shields.io/gem/v/formalism-r18n_errors.svg?style=flat-square)](https://rubygems.org/gems/formalism-r18n_errors)

Errors for [Formalism](https://github.com/AlexWayfer/formalism)
via [R18n](https://github.com/r18n/r18n).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'formalism-r18n_errors'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install formalism-r18n_errors
```

## Usage

```ruby
require 'formalism/r18n_errors'

module MyProject
  module Forms
    class Base < Formalism::Form
      include Formalism::R18nErrors

      def initialize(*)
        ## This is an example, but some value is required
        @errors_key = self.class.name.split('::')[2].underscore.to_sym

        super
      end
    end

    class GeoLocation < Base
      field :address
    end

    class User < Base
      field :name, String

      ## `:errors_key` can be changed for nested forms
      nested :location, GeoLocation, errors_key: :geolocation

      private

      def validate
        ## `add_error` is the alias for `errors.add errors_key, *` (`:user` in this case)
        add_error :name, :is_empty if name.to_s.empty?
      end
    end
  end
end
```

### Validation Helpers

```ruby
require 'formalism/r18n_errors/validation_helpers'

module MyProject
  module Forms
    class Base < Formalism::Form
      include Formalism::R18nErrors
      include Formalism::R18nErrors::ValidationHelpers

      # ...
    end

    class User < Base
      field :name, String
      field :country
      field :city
      field :score, Float
      field :email, String

      nested :location, GeoLocation

      private

      def validate
        ## `errors.user.name.not_entered`
        validate_entry :name

        ## `errors.user.country.not_chosen`
        ## `errors.user.city.not_chosen`
        validate_choice %i[country city]

        ## `errors.user.location.not_provided`
        validate_provision :location

        ## `errors.user.name.greater_than(20)`
        validate_max_length :name, 20

        ## `errors.user.name.less_than(3)`
        validate_min_length :name, 3

        ## `errors.user.score.greater_than(5)`
        ## or
        ## `errors.user.score.less_than(1)`
        validate_range_entry :score, 1..5

        ## Requires `email_address` gem
        ## `errors.user.email.not_valid_email`
        validate_email :email

        ## `errors.user.key.not_valid_uuid`
        validate_uuid :key

        ## Requires `formalism-model_form` gem
        ## `errors.user.email.already_taken`
        validate_uniqueness :email
        ## `errors.user.itself.already_exists.country_and_city`
        validate_uniqueness %i[country city]
      end
    end
  end
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies.

Then, run `toys rspec` to run the tests.

To install this gem onto your local machine, run `toys gem install`.

To release a new version, run `toys gem release %version%`.
See how it works [here](https://github.com/AlexWayfer/gem_toys#release).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/AlexWayfer/formalism-r18n_errors).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
