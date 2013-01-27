module RequestHelper
  def label_class(status)
    # Set the style based on the status type.
    if status.default?
      return 'label-success'
    elsif status.closed?
      return 'label-inverse'
    end
  end

  def severity_class(severity)
    case severity
    when 'minor'
      ''
    when 'moderate'
      'label-info'
    when 'major'
      'label-warning'
    when 'critical'
      'label-error'
    end
  end
end
