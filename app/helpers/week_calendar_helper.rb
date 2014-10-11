module WeekCalendarHelper
  
  def week_calendar(date = Date.today, &block)
    WeekCalendar.new(self, date, block).list
  end

  class WeekCalendar < Struct.new(:view, :date, :callback)
    HEADER = %w[Lun Mar Mer Gio Ven Sab Dom]
    START_DAY = :monday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        header + week_rows
      end
    end


    def list

      content_tag :ul, class: "week-calendar" do
        day_rows
      end
    end

    def header
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << "today" if day == Date.today
      classes << "notmonth" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end


    

    def day_rows

      days.map do |day|
        content_tag :li, view.capture(day, &callback)
      end.join.html_safe

    end

    def days
      first = date.beginning_of_week(START_DAY)
      last = date.end_of_week.end_of_week(START_DAY)
      (first..last).to_a
    end

  end



end