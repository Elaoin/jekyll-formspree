# Changelog

## 0.1.0 — unreleased

### Changed

- The default form posts to `https://formspree.io/f/<id>`, the current
  Formspree endpoint, instead of the legacy `https://formspree.io/<id>`.
  The prefix can be changed with `formspree: endpoint:` in `_config.yml`.
- Custom `_includes/formspree.html` templates are rendered in the page's
  Liquid context: `page`, `site`, `layout` and `{% include %}` now work
  inside them. `formspree_id` is still available, and the new
  `formspree_url` holds the full endpoint URL.
- The default form uses an `email` input, labels tied to their fields and
  `required` attributes. The form has a `formspree-form` class to style it.
- `_includes/formspree.html` is also looked up in the site's theme.

### Added

- A build warning when the form ID is empty, e.g. a missing
  `site.formspree_id`.
- Tests (Minitest) and CI on Ruby 3.3, 3.4 and 4.0 with Jekyll 4.4, and
  Ruby 3.3 with Jekyll 3.10.

### Fixed

- `{% formspree %}` without an ID now fails with a Liquid syntax error.
- The plugin no longer modifies the site payload while rendering.

### Internal

- Code moved to `Jekyll::Formspree::Tag` (no more top-level `Formspree`
  class), with the version in `lib/jekyll/formspree/version.rb`.
- The gemspec declares its Jekyll (>= 3.8, < 5.0) and Ruby (>= 3.1)
  requirements.

## 0.0.7 — 2020-03-27

- Last release of the original plugin.
