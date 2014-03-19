# encoding: utf-8
require "prawn/measurement_extensions"

class GiroPdf < Prawn::Document
  
  include LayoutPdf
  
  def initialize(clienti, view)
    super(:page_size => "A4", 
          :page_layout => :portrait,
          :margin => [1.cm, 15.mm],
          :info => {
              :Title => "giro",
              :Author => "todo-propa",
              :Subject => "giro",
              :Keywords => "giro clienti todo-propa",
              :Creator => "todo-propa",
              :Producer => "Prawn",
              :CreationDate => Time.now
          })

    @clienti = clienti
    @view = view


    @clienti.in_groups_of( 5, false ) do |pages|

      pages.each_with_index do |a, index|
        if a
          draw_header(a, index) 
        end
      end
      
      start_new_page unless page_number >= @clienti.size.to_f / 5
    end

    # @clienti.each_with_index do |c, index|
      
    #   draw_header(c, index)      
    #   #start_new_page unless a == @clienti.last
    # end
  end
  

  def draw_header(cliente, index)
    #move_down 40
    #move_down 10
    text "#{cliente.titolo}", :size => 13    
    #move_down 10

    bounding_box [bounds.left, bounds.top - index * 5.cm], :width => bounds.width, :height => 50.mm do
      
      bounding_box [ bounds.left, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "123", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end
      bounding_box [ bounds.left + 15.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "45", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end
      
      bounding_box [ bounds.left + 35.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "rel 123", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end
      bounding_box [ bounds.left + 50.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "rel 45", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end 

      bounding_box [ bounds.left + 70.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "inglese 123", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end
      bounding_box [ bounds.left + 85.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "inglese 45", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end 


      bounding_box [ bounds.left + 105.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "vac 1", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end
      bounding_box [ bounds.left + 120.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "vac 2", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end       
      bounding_box [ bounds.left + 135.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "vac 3", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end
      bounding_box [ bounds.left + 150.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "vac 4", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end 
      bounding_box [ bounds.left + 165.mm, bounds.top - 1.5.cm], :width => 15.mm, :height => 3.cm do
        stroke_bounds
        draw_text "vac 5", :at => [bounds.left + 1, bounds.top - 6], :size => 6
      end 

    end

    # bounding_box [bounds.left, bounds.top - 63.mm], :width => 72.mm, :height => 8.mm do
    #   # bounding_box [ bounds.left, bounds.top], :width => 8.mm, :height => 8.mm do
    #   #   stroke_bounds
    #   #   draw_text "PAG", :at => [bounds.left + 1, bounds.top - 6], :size => 6
    #   # end
    #   # bounding_box [ bounds.left + 8.mm, bounds.top], :width => 18.mm, :height => 8.mm do
    #   #   stroke_bounds
    #   #   draw_text "DATA", :at => [bounds.left + 1, bounds.top - 6], :size => 6
    #   #   bounding_box [ bounds.left + 1.mm, bounds.top - 2.mm ], :width => bounds.width - 2.mm, :height => 6.mm do
    #   #     #text "#{l(@fattura.data, :format => :only_date)}", :align => :center, :valign => :center, :size => 8
    #   #   end
    #   # end
    #   # bounding_box [bounds.left + 26.mm, bounds.top], :width => 18.mm, :height => 8.mm do
    #   #   stroke_bounds
    #   #   draw_text "NUMERO", :at => [bounds.left + 1, bounds.top - 6], :size => 6
    #   #   bounding_box [ bounds.left + 1.mm, bounds.top - 2.mm ], :width => bounds.width - 2.mm, :height => 6.mm do
    #   #     #text "#{@fattura.numero}", :align => :center, :valign => :center, :size => 8
    #   #   end
    #   # end
    #   # bounding_box [bounds.left + 44.mm, bounds.top], :width => 28.mm, :height => 8.mm do
    #   #   stroke_bounds
    #   #   draw_text "COD.CLIENTE", :at => [bounds.left + 1, bounds.top - 6], :size => 6
    #   # end
    # end
  end


  def pieghi_di_libri?(cliente)
    #stroke_rectangle [0, bounds.top - 100], 16, 150
    text_box("PIEGHI DI LIBRI",
            at: [0, bounds.top - 250],
            size: 13, style: :bold, rotate: 90) # if cliente.tag_list.find_index("posta")
  end
  
  def note(cliente)
    move_down 40
    stroke_horizontal_rule
    move_down 10
    text "#{cliente.note}", :size => 13
    text "tel. #{cliente.telefono}", :size => 13 unless cliente.telefono.blank?
  end
  
  def cliente_number(cliente)
    move_down 20
    text "ordine \##{cliente.id} del #{l(cliente.created_at)}", size: 13, style: :bold
  end
  
  def line_items(cliente)
    move_down 10
    table line_item_rows do
      row(0).font_style = :bold
      columns(1..5).align = :right
      columns(0).width = 200
      columns(1).width = 60
      # columns(2..3).width = 70
      # columns(5).width = 80
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_item_rows
    [["Titolo", "Quantità", "Pr. copertina", "Sconto", "Prezzo unitario", "Importo"]] +
    @righe.per_libro_id.map do |item|
      [
        item.titolo, 
        item.quantita, 
        price(item.prezzo_copertina), 
        
        item.sconto == 0.0 ? price(item.prezzo_copertina - item.prezzo) : item.sconto,
        item.sconto == 0.0 ? price(item.prezzo_unitario) : price(item.prezzo_unitario * ( 100 - item.sconto) / 100), 
        price(item.importo) ]
    end
  end
  
  def price(num)
    
    (num * 100).modulo(2) == 0 ? precision = 2 : precision = 3
    
    @view.number_to_currency(num, :locale => :it, :format => "%n %u", :precision => precision)
  end
  
  def l(data)
    @view.l data, :format => :only_date
  end
  
  def t(data)
    @view.t data
  end
  
  def totali(cliente)  
    move_down(10)
    text "Totale copie: #{cliente.totale_copie}", :size => 14, :style => :bold
    text "Totale importo: #{price(cliente.totale_importo)}", :size => 14, :style => :bold
  end
  
  def intestazione
    logo
    agente(current_user) unless current_user.nil?
  end
  
  def destinatario(cliente)
  
    bounding_box [bounds.width / 2.0, bounds.top - 150], :width => bounds.width / 2.0, :height => 100 do
      #stroke_bounds
      text "#{cliente.destinatario}", :size => 14, :style => :bold, :spacing => 4
      #move_down(3)
      text "#{cliente.cliente.cognome} #{cliente.cliente.nome}",  :size => 14, :style => :bold, :spacing => 4      
      text cliente.cliente.ragione_sociale,  :size => 14, :style => :bold, :spacing => 4
      text cliente.cliente.indirizzo,  :size => 12
      text cliente.cliente.cap + ' ' + cliente.cliente.frazione  + ' ' + cliente.cliente.comune  + ' ' + cliente.cliente.provincia,  :size => 12

    end
  end
  
  def current_user
    @view.current_user || @clienti.first.cliente.user
  end

end
