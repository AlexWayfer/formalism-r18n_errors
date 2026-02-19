# Changelog

## Unreleased

## 1.0.0 (2026-02-20)

*   Drop Ruby 3.0 and 3.1 support.
*   Add Ruby 3.4 and 4.0 support.
*   Update runtime dependencies.
*   Update development dependencies.
*   Resolve new RuboCop offenses.
*   Improve CI config.

## 0.6.0 (2025-01-06)

*   Drop Ruby 2.6 and 2.7 support.
*   Add Ruby 3.2, 3.3 and 3.4 support.
*   Allow `formalism` version 0.6.
*   Replace `uuid` gem with inline simple Regexp.
    This gem is outdated, it's dependencies give warnings.
    We used just 1 method for validation.
*   Fix specs for Ruby 3.
*   Update development dependencies.
*   Resolve new RuboCop offenses.
*   Move development dependencies from `gemspec` into `Gemfile`.
*   Switch `email_address` development dependency to fork version.

## 0.5.1 (2022-09-24)

*   Allow `gorilla_patch` version 5.
*   Improve CI.

## 0.5.0 (2022-09-24)

*   Update `formalism` to a new version.
*   Add Ruby 3.1 support.
*   Update development dependencies.
*   Resolve RuboCop offenses.
*   Improve gemspec metadata.
*   Add `bundle-audit` CI task.

## 0.4.0 (2021-04-16)

*   Add `to_a` alias for `translations` method.
    Fix an error with `#result` call of failed `Formalism::Form::Outcome`.
*   Support Ruby 3.
*   Update development dependencies.

## 0.3.2 (2020-09-28)

*   Add `#validate_uuid` validation helper.
*   Use real gems as development dependencies for tests.

## 0.3.1 (2020-09-28)

*   Update `formalism` to a new version.

## 0.3.0 (2020-09-27)

*   Support endless ranges in `#validate_range_entry`.
*   Drop Ruby 2.5 support.

## 0.2.0 (2020-09-24)

*   Update `formalism` to a fixed version.

## 0.1.3 (2020-09-23)

*   Add specs for anything, especially for `ValidationHelpers`.
    Make code coverage 100%.
*   Add documentation about `ValidationHelpers`.

## 0.1.2 (2020-09-22)

*   Require `gorilla_patch/blank` before its usage.

## 0.1.1 (2020-09-22)

*   Fix the issue with unknown `Forwardable` constant.

## 0.1.0 (2020-07-10)

*   Initial release.
