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

end
