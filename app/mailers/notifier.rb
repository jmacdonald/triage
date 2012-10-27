class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def assignment(request)
    @assignee = request.assignee
    @url = request_url(request)
    @request = request
    mail(to: @assignee.email, subject: "You've been assigned a request")
  end

  def comment(comment, users)
    @comment = comment
    email_addresses = users.collect {|user| user.email}
    mail(to: email_addresses, subject: "#{comment.user.name} commented on #{comment.request}")
  end

  class Preview < MailView
    def assignment
      request = Request.first
      Notifier.assignment(request)
    end

    def comment
      comment = Comment.first
      Notifier.comment(comment, [comment.request.requester])
    end
  end
end
