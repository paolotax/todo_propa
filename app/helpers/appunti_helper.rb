module AppuntiHelper

  def show_status_css(status)
    case status 
      when 'completato'
        content_tag :div, "", { :id => 'status_span', :class => 'done'}
      when "in_sospeso"
        content_tag :div, "", { :id => 'status_span', :class => 'sosp'}
      else  
        content_tag :div, "", { :id => 'status_span', :class => 'active'}
    end
  end

end
