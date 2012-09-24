require "prawn/measurement_extensions"

class EtichettaPdf < Prawn::Document
  
  include LayoutPdf
  
  def initialize(appunti, view, options = {})
    
    defaults = {
      page_layout:   :landscape,
      page_size:     "A4",
      top_margin:    0,
      left_margin:   0,
      bottom_margin: 0,
      right_margin:  0,
      columns:       1,
      labels_per_page: 1,
      destinatario_top:  5.mm,
      destinatario_left: 5.mm,
            
    }

    options = options.reverse_merge(defaults)
    
    #raise options.inspect
    
    super(page_size:     options[:page_size], 
          page_layout:   options[:page_layout], 
          top_margin:    options[:top_margin],
          left_margin:   options[:left_margin],
          bottom_margin: options[:bottom_margin],
          right_margin:  options[:right_margin],
          info: {
              :Title => "etichette",
              :Author => "todo-propa",
              :Subject => "etichette",
              :Keywords => "sovrapacchi appunti todo-propa",
              :Creator => "todo-propa",
              :Producer => "Prawn",
              :CreationDate => Time.now
          })

    @labels_per_page = options[:labels_per_page]
    @columns         = options[:columns]
    @rows            = @labels_per_page / @columns
    
    @label_width  = bounds.width / @columns
    @label_height = (bounds.height) / @rows   
    
    @print_logo   = options[:print_logo]
    @print_pieghi = options[:print_pieghi]
    
    @appunti = appunti
    @view = view
    
    @destinatario_top  = options[:destinatario_top]
    @destinatario_left = options[:destinatario_left]
    

    if options[:start_from]
      (1..options[:start_from].to_i).each { @appunti.insert(0, nil) }
    end

    @appunti.in_groups_of( @labels_per_page, false ) do |pages|
      num_row = 0
      pages.in_groups_of(@columns, false) do |rows|
        rows.each_with_index do |a, index|
          if a
            etichetta(a, index, num_row)
          end
        end  
        num_row += 1
      end
      
      start_new_page unless page_number >= @appunti.size.to_f / @labels_per_page
    end
    
  end  
    
  def etichetta(appunto, num_etichetta, num_row)
    
    left = num_etichetta * @label_width

 
    top  =  bounds.top - (num_row * @label_height)
     
    bounding_box [ left, top ], :width => @label_width, :height => @label_height do
       #stroke_bounds
       
       if @print_logo == "small"       
         logo_small
         agente_small(current_user)
       end
       
       if @print_pieghi
         text_box "PIEGHI DI LIBRI", at: [ bounds.left + 3.mm, bounds.top - 6.8.cm], size: 11, style: :bold, rotate: 90
       end
       
       destinatario(appunto)
    end
  end
  
  def destinatario(appunto)

    bounding_box [ bounds.left + @destinatario_left, bounds.top - @destinatario_top ], :width => 6.5.cm do
      
      text appunto.destinatario, :size => 14, :style => :bold, :spacing => 4
      move_down 2.mm
      #text "#{appunto.cliente.cognome} #{appunto.cliente.nome}",  :size => 14, :style => :bold, :spacing => 4      
      text appunto.cliente.ragione_sociale,  :size => 14, :style => :bold, :spacing => 4
      text appunto.cliente.indirizzo,  :size => 12
      text appunto.cliente.cap + ' ' + appunto.cliente.frazione  + ' ' + appunto.cliente.comune  + ' ' + appunto.cliente.provincia,  :size => 12
    end
  end

  def current_user
    @view.current_user
  end
    
end