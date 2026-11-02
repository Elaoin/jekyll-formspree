# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# CI tests several Jekyll versions: JEKYLL_VERSION="~> 3.10" bundle install
gem "jekyll", ENV.fetch("JEKYLL_VERSION", "~> 4.4")

gem "minitest", "~> 5.0"
gem "rake", "~> 13.0"

# Ruby 3.4+ no longer bundles these; Jekyll 3.x still needs them.
gem "base64"
gem "bigdecimal"
gem "csv"
gem "logger"
