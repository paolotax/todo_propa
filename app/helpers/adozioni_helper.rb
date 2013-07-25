module AdozioniHelper


  def adozione_stato_label(stato, value)
    label_class = ''
    if stato == "kit"
      label_class = "label-success"
    elsif stato == "saggio"
      label_class = "label-warning"
    elsif stato == "kit no saggio"
      label_class = "label-important"
    end    
    content_tag :span, value, class: "label #{label_class}" 
  end

  def adozioni_stato_tag(stato, adozioni, remote = true)
 	  render 'adozioni/adozioni_stato', stato: stato, adozioni: adozioni, remote: remote 
  end

end
