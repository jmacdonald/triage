module RequestHelper
  def label_class(status)
    # Set the style based on the status type.
    if status.default?
      return 'label-success'
    elsif status.closed?
      return 'label-inverse'
    end
  end
end
