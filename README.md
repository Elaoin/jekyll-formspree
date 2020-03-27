# Jekyll Formspree

This Jekyll pluging provides a tag that generate form snippets to add Formspree's contact forms to your site.

## Installation

Add this line to your Gemfile:

```ruby
group :jekyll_plugins do
  gem "jekyll-formspree"
end
```

And then execute:

    $ bundle

Alternatively install the gem yourself as:

    $ gem install jekyll-formspree

and put this in your ``_config.yml``

```yaml
plugins: [jekyll-formspree]
```

## Usage

```
 {% formspree "MY_FORMSPREE_ID" %}
```
or using variables/front matter

```
{% formspree site.formspree_id %}
```

## Result

By default the plugin will output the following code

```markup
<style>
  .form-container { max-width: 100%; }
  .form-container input { position: relative; top: 0; left: 0; width: 100%; height: 20px; padding: 0 ; }
  .form-container textarea { position: relative; top: 0; left: 0; width: 100%; height: 80px; padding: 0; }
</style>
<form action="https://formspree.io/MY_FORMSPREE_ID" method="POST" class="form-container">
  <label>Your email:</label><br />
  <input type="text" name="_replyto" />
  <label>Your message:</label><br />
  <textarea name="message"></textarea>
  <button type="submit">Send</button>
</form>
```

You can specify your own snippet by creating a partial ``_includes/formspree.html``. Inside that partial the Formspree ID is available as ``{{ formspree_id }}``.
