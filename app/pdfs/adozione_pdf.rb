# encoding: utf-8
require "prawn/measurement_extensions"

class AdozionePdf < Prawn::Document
  
  include LayoutPdf
  
  def initialize(adozioni, view)
    super(:page_size => "A4", 
          :page_layout => :portrait,
          :margin => [1.cm, 15.mm],
          :info => {
              :Title => "sovrapacchi",
              :Author => "you-propa",
              :Subject => "sovrapacchi",
              :Keywords => "sovrapacchi adozioni you-propa",
              :Creator => "you-propa",
              :Producer => "Prawn",
              :CreationDate => Time.now
          })
    @adozioni = adozioni
    @view = view

    @adozioni.each do |a|
      
      intestazione
      destinatario(a)
      pieghi_di_libri?(a)
      
      note(a)

      start_new_page unless a == @adozioni.last
    end
  end
  
  def pieghi_di_libri?(adozione)
    #stroke_rectangle [0, bounds.top - 100], 16, 150
    text_box("PIEGHI DI LIBRI",
            at: [0, bounds.top - 250],
            size: 13, style: :bold, rotate: 90) # if adozione.tag_list.find_index("posta")
  end
  
  def note(adozione)
    move_down 40
    stroke_horizontal_rule
    move_down 10
    text "Materiale abbinato all'adozione del testo #{adozione.libro.titolo}", :size => 13
    move_down 10
    stroke_horizontal_rule
    move_down 40

    if adozione.libro.titolo == "NEL GIARDINO 1"
      text "Il fascicolo blu NEL GIARDINO SCOPRO 1 non è al momento disponibile.", :size => 13
      text "Sarà mia premura consegnarlo a Settembre con le agende.", :size => 13
    end

    if adozione.kit_1 == "consegnato"
      text "saggio già consegnato", :size => 13
    end  

  end
    
  def l(data)
    @view.l data, :format => :only_date
  end
  
  def t(data)
    @view.t data
  end
  

  def intestazione
    logo
    agente(current_user) unless current_user.nil?
  end
  
  def destinatario(adozione)
  
    bounding_box [bounds.width / 2.0, bounds.top - 150], :width => bounds.width / 2.0, :height => 100 do
      #stroke_bounds
      text "Classe #{adozione.classe.classe} #{adozione.classe.sezione}", :size => 25, :style => :bold, :spacing => 4
      #move_down(3)
      #text "#{adozione.classe.insegnanti}",  :size => 14, :style => :bold, :spacing => 4      
      text adozione.classe.cliente.ragione_sociale,  :size => 14, :style => :bold, :spacing => 4
      text adozione.classe.cliente.indirizzo,  :size => 12
      text adozione.classe.cliente.cap + ' ' + adozione.classe.cliente.frazione  + ' ' + adozione.classe.cliente.comune  + ' ' + adozione.classe.cliente.provincia,  :size => 12

    end
  end
  
  def current_user
    @view.current_user || @adozioni.first.cliente.user
  end

end
