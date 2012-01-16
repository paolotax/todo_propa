# encoding: utf-8
require "prawn/measurement_extensions"

class AppuntoPdf < Prawn::Document
  
  include LayoutPdf
  
  def initialize(appunti, view)
    super(:page_size => "A4", 
          :page_layout => :portrait,
          :margin => [1.cm, 15.mm],
          :info => {
              :Title => "sovrapacchi",
              :Author => "todo-propa",
              :Subject => "sovrapacchi",
              :Keywords => "sovrapacchi appunti todo-propa",
              :Creator => "todo-propa",
              :Producer => "Prawn",
              :CreationDate => Time.now
          })
    @appunti = appunti
    @view = view

    @appunti.each do |a|
      
      @righe = a.righe
      intestazione
      destinatario(a)
      pieghi_di_libri?(a)
      
      note(a)
      unless @righe.blank?
        appunto_number(a)
        line_items(a) 
        totali(a)
      end
      
      start_new_page unless a == @appunti.last
    end
  end
  
  def pieghi_di_libri?(appunto)
    #stroke_rectangle [0, bounds.top - 100], 16, 150
    text_box("PIEGHI DI LIBRI",
            at: [0, bounds.top - 250],
            size: 13, style: :bold, rotate: 90) # if appunto.tag_list.find_index("posta")
  end
  
  def note(appunto)
    move_down 40
    stroke_horizontal_rule
    move_down 10
    text appunto.note, :size => 13
    text "tel. #{appunto.telefono}", :size => 13 unless appunto.telefono.blank?
  end
  
  def appunto_number(appunto)
    move_down 20
    text "ordine \##{appunto.id} del #{l(appunto.created_at)}", size: 13, style: :bold
  end
  
  def line_items(appunto)
    move_down 10
    # table line_item_rows, :border_style => :grid,
    #                       :row_colors => ["FFFFFF","DDDDDD"],
    #                       :headers => ["Titolo", "Quantità", "Pr.Copertina", "Prezzo", "Importo"],
    #                       :align => { 0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right },
    #                       :header => true
  end

  def line_item_rows
    @righe.per_libro_id.map do |item|
      [item.titolo, item.quantita, price(item.prezzo_copertina), price(item.prezzo), price(item.prezzo) ]
    end
  end
  
  def price(num)
    @view.number_to_currency(num, :locale => :it)
  end
  
  def l(data)
    @view.l data, :format => :only_date
  end
  
  def t(data)
    @view.t data
  end
  
  def totali(appunto)  
    move_down(10)
    text "Totale copie: #{appunto.totale_copie}", :size => 14, :style => :bold
    text "Totale importo: #{price(appunto.totale_importo)}", :size => 14, :style => :bold
  end
  
  def intestazione
    logo
    agente(current_user) unless current_user.nil?
  end
  
  def destinatario(appunto)
  
    bounding_box [bounds.width / 2.0, bounds.top - 150], :width => bounds.width / 2.0, :height => 100 do
      #stroke_bounds
      text appunto.destinatario, :size => 12, :style => :bold, :spacing => 4

      if !appunto.scuola.indirizzi.empty?
        indirizzo = appunto.scuola.indirizzi.first
        text indirizzo.destinatario,  :size => 14, :style => :bold, :spacing => 4
        text indirizzo.indirizzo
        text indirizzo.cap + ' ' + indirizzo.citta + ' ' + indirizzo.provincia
        # non funziona to_s carriage return 
        # pdf.text appunto.scuola.indirizzi.first.to_s unless appunto.scuola.indirizzi.empty? 
      else
        text appunto.scuola.nome_scuola, :size => 14, :style => :bold, :spacing => 16
        text appunto.scuola.citta + " " + appunto.scuola.provincia, :size => 12
      end
    end
  end
  
  def current_user
    @view.current_user
  end
  
  
  
end


