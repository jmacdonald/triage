module CommentHelper
  def embolden_mentions(content)
    # Escape the html.
    modified_content = ERB::Util.html_escape content

    # Embolden the mentions.
    modified_content.gsub! /@\w+/ do |mention|
      "<strong>#{mention}</strong>"
    end

    # Return a version of the content that won't be escaped.
    modified_content.html_safe
  end
end
