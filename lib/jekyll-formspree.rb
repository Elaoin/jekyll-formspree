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
      %Q{<style>.form-container { max-width: 100%; } .form-container input { position: relative; top: 0; left: 0; width: 100%; height: 20px; padding: 0 ; } .form-container textarea { position: relative; top: 0; left: 0; width: 100%; height: 80px; padding: 0; } </style> <form action="https://formspree.io/#{ @formspree_id }" method="POST" class='form-container'> <label>Your email:</label><br /><input type="text" name="_replyto" /> <label>Your message:</label><br /><textarea name="message"></textarea> <button type="submit">Send</button> </form>}
    end
  end

  Liquid::Template.register_tag "formspree", self
end
