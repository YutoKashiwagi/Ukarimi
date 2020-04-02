module ApplicationHelper
  def full_title(title)
    base_title = 'Ukarimi'
    if title.blank?
      base_title
    else
      "#{title} | #{base_title}"
    end
  end
end
