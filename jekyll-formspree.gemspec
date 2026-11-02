# frozen_string_literal: true

require_relative "lib/jekyll/formspree/version"

Gem::Specification.new do |s|
  s.name        = "jekyll-formspree"
  s.version     = Jekyll::Formspree::VERSION
  s.summary     = "Liquid tag that renders Formspree contact forms in Jekyll sites"
  s.description = "Adds a {% formspree %} Liquid tag to Jekyll that renders a Formspree " \
                  "contact form, using your own _includes/formspree.html template or a default one."
  s.authors     = ["Elaoin"]
  s.email       = "julien@elaoin.com"
  s.homepage    = "https://github.com/Elaoin/jekyll-formspree"
  s.license     = "MIT"

  s.files = Dir["lib/**/*.{rb,html}", "LICENSE", "README.md", "CHANGELOG.md"]
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 3.1"
  s.add_dependency "jekyll", ">= 3.8", "< 5.0"

  s.metadata = {
    "source_code_uri"       => "https://github.com/Elaoin/jekyll-formspree",
    "changelog_uri"         => "https://github.com/Elaoin/jekyll-formspree/blob/master/CHANGELOG.md",
    "bug_tracker_uri"       => "https://github.com/Elaoin/jekyll-formspree/issues",
    "rubygems_mfa_required" => "true",
  }
end
