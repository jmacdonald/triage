module ApplicationHelper
  def pretty_date(date)
    date.strftime "%B #{@request.created_at.day.ordinalize}, %Y at %l:%M%P"
  end
end
