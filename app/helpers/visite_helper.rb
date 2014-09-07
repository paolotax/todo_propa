module VisiteHelper

  def visita_label(data)

    if data

      oggi = Date.today

      if data == oggi 
        label_class = "label-warning"
        format = :day_of_month
      elsif data > oggi
        label_class = "label-important"
        format = :day_of_month
      elsif data < oggi && data > oggi - 1.month 
        label_class = "label-info"
        format = :day_of_month
      elsif data < oggi && data <= oggi - 1.month 
        label_class = ""
        format = :month_year

      end

      content_tag :div, :class => 'next-visita' do
        link_to  giro_path(giorno: data)do
          content_tag( :span, l(data, format: format), class: "label #{label_class}")
        end
      end
    end
  end


end