module WordHelper
  def title(title="Karbon Hero")
    content_for(:title, title)
  end

  def date_format(date, type)
    object = date.present? ? date.strftime("%d %b %Y, %I:%M %p") : nil if type.eql?("datetime")
    object = date.present? ? date.strftime("%d %b %Y") : nil if type.eql?("date")

    return object
  end

  def date_only(data)
    data.present? ? data.strftime("%A, %-d %b %Y") : nil
  end

  def datetime_only(data)
    data.present? ? data.strftime("%A, %-d %b %Y %I:%M %p") : nil
  end

  def normalize(value)
    value.underscore.humanize.capitalize if value.present?
  end
end
