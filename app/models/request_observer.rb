class RequestObserver < ActiveRecord::Observer
  def after_update(request)
    if request.assignee_id_changed? and request.assignee_id.present?
      RequestMailer.assignment_email(request).deliver
    end
  end
end
