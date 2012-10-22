class RequestMailer < ActionMailer::Base
  default from: "from@example.com"

  def assignment_email(request)
    @assignee = request.assignee
    @url = request_url(request)
    @request = request
    mail(to: @assignee.email, subject: "You've been assigned a request")
  end

  class Preview < MailView
    def assignment
      request = Request.first
      RequestMailer.assignment_email(request)
    end
  end
end
