module ApplicationHelper

  def avatar_small_thumb(user)
    unless user.nil?
      if user.avatar.nil? || user.avatar.blank?
        image_tag('avatar.png', size: "30x30")
      else
        if user.avatar.small_thumb.file.exists?
          image_tag user.avatar.small_thumb
        end
      end
    end
  end

  def avatar_thumb(user)
    unless user.nil?
      if user.avatar.nil? || user.avatar.blank?
        image_tag('avatar.png', size: "150x150", class: "avatar_thumb")
      else
        if user.avatar.thumb.file.exists?
          image_tag user.avatar.thumb, class: "avatar_thumb"
        end
      end
    end
  end
  def birthdays
    User.where("to_char( birthday,'MMDD') >= to_char(current_date,'MMDD') AND to_char( birthday,'MMDD') <  to_char(current_date + integer '3','MMDD')")
    # .order("strftime('%m%d', birthday)")
  end
  def users
    User.all
  end
  def projects
    Project.all
  end
  def releases
    Project.where(" release >= ? AND  release <= ?", Date.today,  (Date.today+2.day))
  end
  def month_calendar_td_options
    ->(start_date, current_calendar_date) {
      today = Date.today
      td_class = ["day"]
      td_class << "today"  if today == current_calendar_date
      td_class << "past"   if today > current_calendar_date
      td_class << "future" if today < current_calendar_date
      td_class << "prev-month"    if start_date.month != current_calendar_date.month && current_calendar_date < start_date
      td_class << "next-month"    if start_date.month != current_calendar_date.month && current_calendar_date > start_date
      td_class << "current-month" if start_date.month == current_calendar_date.month
      td_class << "wday-#{current_calendar_date.wday.to_s}"
      td_class << 'active-date' if current_calendar_date == @date
      {class: td_class.join(' '), data: {day: current_calendar_date}}
    }
  end
  def inline_svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read[/<svg[^>]*>([\s\S]*?)<\/svg>/].encode('UTF-8', :invalid => :replace, :undef => :replace)
    end
  end

  def user_task_progress(u)
    @task = u.tasks_requester.where(:status => "in_progress")
    end
  def user_task_open_today(u)
    @task = u.tasks_requester.where.not(:status => "closed")
  end


end
