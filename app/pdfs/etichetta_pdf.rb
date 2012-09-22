require "prawn/measurement_extensions"

class EtichettaPdf < Prawn::Document
  
  include LayoutPdf
  
  def initialize(appunti, view)
    super(:page_size => "A4", 
          :page_layout => :portrait,
          :margin => [4.mm, 0],
          :info => {
              :Title => "etichette",
              :Author => "todo-propa",
              :Subject => "etichette",
              :Keywords => "sovrapacchi appunti todo-propa",
              :Creator => "todo-propa",
              :Producer => "Prawn",
              :CreationDate => Time.now
          })
    
    @appunti = appunti.insert(0, nil).insert(0, nil).insert(0, nil)
    @view = view

    @appunti.in_groups_of( 8, false ) do |pages|
      
      pages.each_with_index do |a, index|
        if a
          etichetta(a, index + 1)
        end
      end
      
      start_new_page unless page_number >= @appunti.size.to_f / 8
    end
  end  
    
  def etichetta(appunto, num_etichetta)
    
    if num_etichetta.even?
      left = 10.5.cm
    else
      left = 0
    end

    top  =  bounds.top - (((num_etichetta - 1) / 2) * 7.2.cm)
    
    bounding_box [ left, top ], :width => 10.5.cm, :height => 7.2.cm do
      #stroke_bounds
      logo_small
      agente_small(current_user)
      text_box "PIEGHI DI LIBRI", at: [ bounds.left + 3.mm, bounds.top - 6.8.cm], size: 11, style: :bold, rotate: 90
      
      destinatario(appunto)
    end
  end
  
  def destinatario(appunto)

    bounding_box [30.mm , bounds.top - 3.cm], :width => 6.5.cm do
      move_down 10
      text appunto.destinatario, :size => 14, :style => :bold, :spacing => 4
      #move_down(3)
      text "#{appunto.cliente.cognome} #{appunto.cliente.nome}",  :size => 14, :style => :bold, :spacing => 4      
      text appunto.cliente.ragione_sociale,  :size => 14, :style => :bold, :spacing => 4
      text appunto.cliente.indirizzo,  :size => 12
      text appunto.cliente.cap + ' ' + appunto.cliente.frazione  + ' ' + appunto.cliente.comune  + ' ' + appunto.cliente.provincia,  :size => 12
    end
  end

  def current_user
    @view.current_user
  end
    
end