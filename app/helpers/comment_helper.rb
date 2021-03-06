module CommentHelper
  def escape(content)
    ERB::Util.html_escape(content)
  end

  def embolden_mentions(content)
    # Embolden the mentions.
    content.gsub /@\w+/ do |mention|
      # Embolden the mention if the user exists.
      if User.exists? username: mention[1..-1]
        "<strong>#{mention}</strong>"
      else
        mention
      end
    end
  end

  def link_references(content)
    content.gsub /#\w+/ do |reference|
      # Find the referenced request and link to it, if found.
      begin
        request = Request.find reference[1..-1]
        "<a href=\"#{request_url(request)}\">##{request.id}</a>"
      rescue ActiveRecord::RecordNotFound
        reference
      end
    end
  end

  def enrich(content)
    link_references(embolden_mentions escape content).html_safe
  end

  def request_role(request, user)
    if user == request.requester
      'Requester'
    elsif user == request.assignee
      'Assigned ' + user.role.titleize
    else
      user.role.titleize
    end
  end
end
