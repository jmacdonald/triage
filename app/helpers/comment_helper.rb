module CommentHelper
  def embolden_mentions(comment)
    comment.content.gsub /@\w+/ do |mention|
      "<strong>#{mention}</strong>"
    end
  end
end
