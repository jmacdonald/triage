class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    request = comment.request
    users = []

    if request.assignee.nil?
      if comment.user != request.requester
        users << request.requester
      end
    else
      if comment.user == request.assignee
        users << request.requester
      elsif comment.user == request.requester
        users << request.assignee
      else
        users << request.requester
        users << request.assignee
      end
    end

    # Find any user mentions in the comment.
    usernames = comment.content.scan(/@\w+/)

    # Drop the leading @ sign on all of the matches.
    usernames.collect! {|username| username[1..username.length]}

    # Add the associated users to the list of recipients.
    users += User.where(username: usernames)

    Notifier.comment(comment, users).deliver unless users.empty?
  end
end
