require "jekyll"
class Formspree < Liquid::Tag

  def initialize(tagName, content, tokens)
    super
    @content = content
  end

  def render(context)
    @formspree_id = "#{context[@content.strip]}"

    site = context.registers[:site]
    tmpl_path = File.join site.in_source_dir(site.config["includes_dir"].to_s), "formspree.html"
    if File.exist?(tmpl_path)
      tmpl = File.read tmpl_path
      tmpl = (Liquid::Template.parse tmpl).render site.site_payload.merge!({"formspree_id" => @formspree_id})
    else
      %Q{<form action="https://formspree.io/#{ @formspree_id }" method="POST" ><p><label>Your email:</label><br /><input type="text" name="_replyto"></p><p><label>Your message:</label><br /><textarea name="message"></textarea></p><p><button type="submit">Send</button></p></form>}
    end
  end

  Liquid::Template.register_tag "formspree", self
end
