module ApplicationHelper
  def relative_time_for(timestamp)
    return "" unless timestamp

    diff = (Time.current - timestamp).to_i
    minutes = diff / 60
    hours   = diff / 3600
    days    = diff / 86_400

    if minutes < 1
      t("time.just_now")
    elsif minutes < 60
      t("time.x_minutes_ago", count: minutes)
    elsif hours < 24
      t("time.x_hours_ago", count: hours)
    elsif days < 5
      t("time.x_days_ago", count: days)
    else
      l(timestamp, format: :long)
    end
  end
end
