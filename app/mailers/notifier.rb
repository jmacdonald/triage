class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def assignment(request)
    @assignee = request.assignee
    @url = request_url(request)
    @request = request
    mail(to: @assignee.email, subject: "You've been assigned a request")
  end

  class Preview < MailView
    def assignment
      request = Request.first
      Notifier.assignment(request)
    end
  end
end
