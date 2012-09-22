module LayoutPdf


  def logo
    bounding_box([0, bounds.top], :width => bounds.width / 2.0, :height => 100) do
      giunti = "#{Rails.root}/public/images/giunti_scuola.jpg"
      image giunti, :width => 200, :height => 35, :at => [-10, bounds.top]
    end
  end
  
  def agente(user)
    bounding_box([bounds.width / 2.0, bounds.top], :width => bounds.width / 2.0, :height => 100) do
      #stroke_bounds
      font_size 9
      text "Agente di Zona - #{user.nome_completo}", :size => 11, :align => :right
      text "Via Zanardi 376/2",  :align => :right
      text "40131 Bologna BO",   :align => :right
      move_down 5
      text "tel 051 6342585  fax 051 6341521", :align => :right
      text "cell #{user.telefono}", :align => :right
      text "email #{user.email}", :align => :right
      move_down 5
    end
  end
  
  
  
  def logo_small
    bounding_box([bounds.left + 3.mm, bounds.top - 2.mm], :width => bounds.width / 2.0) do
      giunti = "#{Rails.root}/public/images/giunti_scuola.jpg"
      image giunti, :width => 4.cm, :height => 0.8.cm
    end
  end
  
  def agente_small(user)
    bounding_box([bounds.width / 2.0, bounds.top - 3.mm], :width => bounds.width / 2.0 - 2.mm ) do
      #stroke_bounds
      font_size 8
      text "#{user.nome_completo.upcase}", :size => 10, :align => :right, style: :bold
      text "Via Zanardi 376/2 - 40131 - Bologna BO",    :align => :right
      text "tel 051 6342585  cell #{user.telefono}",    :align => :right
    end
  end
  
end