module CommentHelper
  def embolden_mentions(content)
    content.gsub /@\w+/ do |mention|
      "<strong>#{mention}</strong>"
    end
  end
end
