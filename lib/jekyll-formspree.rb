# frozen_string_literal: true

require "jekyll"
require_relative "jekyll/formspree/version"
require_relative "jekyll/formspree/tag"

Liquid::Template.register_tag("formspree", Jekyll::Formspree::Tag)
