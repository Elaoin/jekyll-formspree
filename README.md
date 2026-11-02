# Jekyll Formspree

[![Gem Version](https://badge.fury.io/rb/jekyll-formspree.svg)](https://badge.fury.io/rb/jekyll-formspree)
[![Tests](https://github.com/Elaoin/jekyll-formspree/actions/workflows/ci.yml/badge.svg)](https://github.com/Elaoin/jekyll-formspree/actions/workflows/ci.yml)

A Jekyll plugin that adds a `{% formspree %}` Liquid tag to render a
[Formspree](https://formspree.io) contact form.

Requires Jekyll 3.8 to 4.x and Ruby 3.1 or later.

## Installation

Add the gem to your `Gemfile`:

```ruby
group :jekyll_plugins do
  gem "jekyll-formspree"
end
```

then run `bundle install`. If you list plugins in `_config.yml`, add it there too:

```yaml
plugins:
  - jekyll-formspree
```

> GitHub Pages' built-in Jekyll build only runs [allow-listed plugins](https://pages.github.com/versions/).
> To use this plugin there, build the site with a GitHub Actions workflow.

## Usage

Use your form ID, as shown on Formspree (`https://formspree.io/f/<form ID>`):

```liquid
{% formspree "xyzabcde" %}
```

or read it from a variable, for example from `_config.yml` (`formspree_id: xyzabcde`)
or from the page's front matter:

```liquid
{% formspree site.formspree_id %}
{% formspree page.form_id %}
```

If the ID is empty, the build prints a warning.

## Default form

Without a custom template, the tag renders:

```html
<form class="formspree-form" action="https://formspree.io/f/xyzabcde" method="POST" accept-charset="utf-8">
  <label for="formspree-email">Your email</label>
  <input type="email" id="formspree-email" name="email" autocomplete="email" required>
  <label for="formspree-message">Your message</label>
  <textarea id="formspree-message" name="message" rows="5" required></textarea>
  <button type="submit">Send</button>
</form>
```

preceded by a few lines of CSS scoped to `.formspree-form`.

## Custom form

Create `_includes/formspree.html` in your site (or in your theme). The tag
renders it in the page's context, so `page`, `site` and `{% include %}`
work as usual, with two extra variables:

| Variable        | Value                                 |
|-----------------|---------------------------------------|
| `formspree_id`  | the form ID                           |
| `formspree_url` | `https://formspree.io/f/<form ID>`    |

```html
<form action="{{ formspree_url }}" method="POST">
  <input type="email" name="email" required>
  <textarea name="message" required></textarea>
  <input type="hidden" name="_subject" value="Message from {{ page.title }}">
  <button type="submit">Send</button>
</form>
```

## Configuration

The endpoint prefix defaults to `https://formspree.io/f/`. To change it:

```yaml
formspree:
  endpoint: https://formspree.io/f/
```

## Upgrading from 0.0.x

- The default form now posts to `https://formspree.io/f/<id>` instead of
  `https://formspree.io/<id>`. Use the form ID shown in your Formspree dashboard.
- Custom templates keep working unchanged. To use the new endpoint, replace
  `https://formspree.io/{{ formspree_id }}` with `{{ formspree_url }}`.

## Development

```sh
bundle install
bundle exec rake test
JEKYLL_VERSION="~> 3.10" bundle update jekyll && bundle exec rake test
```

## License

MIT, see [LICENSE](LICENSE).
