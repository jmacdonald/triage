class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    request = comment.request
    email_addresses = []

    if request.assignee.nil?
      if comment.user != request.requester
        email_addresses << request.requester
      end
    else
      if comment.user == request.assignee
        email_addresses << request.requester
      elsif comment.user == request.requester
        email_addresses << request.assignee
      else
        email_addresses << request.requester
        email_addresses << request.assignee
      end
    end

    Notifier.comment(comment, email_addresses).deliver unless email_addresses.empty?
  end
end
