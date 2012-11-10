class RequestObserver < ActiveRecord::Observer
  def after_save(request)
    if request.assignee_id_changed? and request.assignee_id.present?
      Notifier.assignment(request).deliver
    end
  end
end
