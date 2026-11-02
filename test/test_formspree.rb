# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
require "fileutils"
require "tmpdir"
require "jekyll"
require "jekyll-formspree"

class TestFormspree < Minitest::Test
  FRONT_MATTER = "---\ntitle: Contact\nform_id: page123\n---\n"

  # Builds a throwaway site and returns the rendered pages, keyed by name.
  def build(pages, includes: {}, config: {})
    Dir.mktmpdir do |dir|
      source = File.join(dir, "src")
      FileUtils.mkdir_p(File.join(source, "_includes"))
      includes.each { |name, body| File.write(File.join(source, "_includes", name), body) }
      pages.each { |name, body| File.write(File.join(source, name), FRONT_MATTER + body) }

      site_config = Jekyll.configuration(
        config.merge("source" => source, "destination" => File.join(dir, "_site"), "quiet" => true)
      )
      Jekyll::Site.new(site_config).process
      pages.keys.to_h { |name| [name, File.read(File.join(dir, "_site", name))] }
    end
  end

  def render(body, **options)
    build({ "index.html" => body }, **options)["index.html"]
  end

  def test_literal_id_renders_default_form
    html = render(%({% formspree "abc123" %}))

    assert_includes html, %(action="https://formspree.io/f/abc123")
    assert_includes html, %(type="email")
    assert_includes html, %(<label for="formspree-message">)
  end

  def test_site_variable_id
    html = render("{% formspree site.formspree_id %}", config: { "formspree_id" => "site456" })

    assert_includes html, %(action="https://formspree.io/f/site456")
  end

  def test_page_variable_id
    assert_includes render("{% formspree page.form_id %}"), %(action="https://formspree.io/f/page123")
  end

  def test_custom_include_gets_context_and_variables
    includes = {
      "formspree.html" => "[{{ formspree_id }}|{{ formspree_url }}|{{ page.title }}|{% include extra.html %}]",
      "extra.html"     => "nested",
    }
    html = render(%({% formspree "abc" %}), includes: includes)

    assert_includes html, "[abc|https://formspree.io/f/abc|Contact|nested]"
  end

  def test_variables_do_not_leak_after_the_tag
    assert_includes render(%({% formspree "abc" %}({{ formspree_id }}))), "</form>\n()"
  end

  def test_several_forms_on_one_page
    html = render(%({% formspree "one" %}{% formspree "two" %}))

    assert_includes html, "https://formspree.io/f/one"
    assert_includes html, "https://formspree.io/f/two"
  end

  def test_endpoint_can_be_configured
    html = render(%({% formspree "abc" %}), config: { "formspree" => { "endpoint" => "https://example.com/forms/" } })

    assert_includes html, %(action="https://example.com/forms/abc")
  end

  def test_id_is_escaped_in_default_form
    html = render("{% formspree site.formspree_id %}", config: { "formspree_id" => %(x"><script>) })

    refute_includes html, "<script>"
    assert_includes html, "x&quot;&gt;&lt;script&gt;"
  end

  def test_missing_id_warns_and_still_renders
    warnings = []
    html = Jekyll.logger.stub(:warn, ->(*args) { warnings << args.join(" ") }) do
      render("{% formspree site.does_not_exist %}")
    end

    formspree_warnings = warnings.grep(/\AFormspree:/)

    assert_includes html, %(action="https://formspree.io/f/")
    assert_equal 1, formspree_warnings.size, warnings.inspect
    assert_match(/empty form ID .*site\.does_not_exist.* in index\.html/, formspree_warnings.first)
  end

  def test_tag_without_id_is_a_syntax_error
    assert_raises(Liquid::SyntaxError) { render("{% formspree %}") }
  end
end
