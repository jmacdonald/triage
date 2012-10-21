class RequestMailer < ActionMailer::Base
  default from: "from@example.com"

  def assignment_email(request)
    @assignee = request.assignee
    @url = request_url(request)
    @request = request
    mail(to: @assignee.email, subject: "You've been assigned a request")
  end
end
