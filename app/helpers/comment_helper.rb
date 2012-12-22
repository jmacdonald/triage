module CommentHelper
  def escape(content)
    # Escape the html and flag it as safe.
    ERB::Util.html_escape(content).html_safe
  end

  def embolden_mentions(content)
    # Embolden the mentions.
    content.gsub! /@\w+/ do |mention|
      "<strong>#{mention}</strong>"
    end
  end
end
