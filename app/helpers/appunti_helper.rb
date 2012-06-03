module AppuntiHelper

  def stato_to_s(appunto)
    if appunto.stato == "P"
      "in_sospeso"
    elsif appunto.stato == "X"
      "completato"
    else
      "da_fare"
    end   
  end

  def show_status_css(stato)
    if stato == 'X'
      content_tag :div, "", { :id => 'status_span', :class => 'done'}
    else
      if stato == "P"
        content_tag :div, "", { :id => 'status_span', :class => 'sosp'}
      else  
        content_tag :div, "", { :id => 'status_span', :class => 'active'}
      end
    end
  end

end
