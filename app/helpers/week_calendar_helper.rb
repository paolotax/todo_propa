module WeekCalendarHelper
  

  def week_calendar(date = Date.today, &block)
    WeekCalendar.new(self, date, block).list
  end

  
  class WeekCalendar < Struct.new(:view, :date, :callback)
    
    START_DAY = :monday
    delegate :content_tag, to: :view


    def list
      content_tag :table, class: "week-calendar table" do
        day_rows
      end
    end


    def day_rows
      days.map do |day|
        content_tag :tr, view.capture(day, &callback)
      end.join.html_safe
    end


    def days
      first = date.beginning_of_week(START_DAY)
      last = date.end_of_week.end_of_week(START_DAY)
      (first..last).to_a
    end
  end

end