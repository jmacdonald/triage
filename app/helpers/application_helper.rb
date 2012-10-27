module ApplicationHelper
  def pretty_date(date)
    date.strftime "%B #{date.day.ordinalize}, %Y at %l:%M%P"
  end
end
