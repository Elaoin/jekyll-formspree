# frozen_string_literal: true

module Jekyll
  module Formspree
    # {% formspree "FORM_ID" %} or {% formspree site.formspree_id %}
    #
    # Renders _includes/formspree.html (from the site, then from the theme),
    # or the default form bundled with this gem. The template is rendered in
    # the current Liquid context, so `page`, `site` and `{% include %}` work,
    # with two extra variables:
    #
    #   formspree_id   the form ID
    #   formspree_url  the form endpoint, https://formspree.io/f/<id>
    #
    # The endpoint prefix can be changed in _config.yml:
    #
    #   formspree:
    #     endpoint: https://formspree.io/f/
    class Tag < Liquid::Tag
      DEFAULT_ENDPOINT = "https://formspree.io/f/"
      INCLUDE_NAME = "formspree.html"
      DEFAULT_TEMPLATE = File.expand_path("default.html", __dir__)

      def initialize(tag_name, markup, parse_context)
        super
        @markup = markup.strip
        raise Liquid::SyntaxError, "Syntax error in 'formspree': usage is {% formspree \"FORM_ID\" %}" if @markup.empty?

        @id_expression = Liquid::Expression.parse(@markup)
      end

      def render(context)
        site = context.registers[:site]
        id = context.evaluate(@id_expression).to_s.strip
        warn_missing_id(context) if id.empty?

        path = template_path(site)
        template = site.liquid_renderer.file(path).parse(File.read(path, **site.file_read_opts))

        context.stack do
          context["formspree_id"] = id
          context["formspree_url"] = endpoint(site) + id
          template.render!(context)
        end
      end

      private

      def endpoint(site)
        config = site.config["formspree"]
        endpoint = config["endpoint"] if config.is_a?(Hash)
        endpoint.to_s.empty? ? DEFAULT_ENDPOINT : endpoint.to_s
      end

      def template_path(site)
        site.includes_load_paths
          .map { |dir| File.join(dir, INCLUDE_NAME) }
          .find { |path| File.file?(path) } || DEFAULT_TEMPLATE
      end

      def warn_missing_id(context)
        page = context.registers[:page]
        where = page && page["path"] ? " in #{page["path"]}" : ""
        Jekyll.logger.warn "Formspree:", "empty form ID for '{% formspree #{@markup} %}'#{where}"
      end
    end
  end
end
