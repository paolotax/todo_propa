module ClientiHelper

  def nested_scuole(scuole)
    scuole.map do |direzione, plessi|
      render(partial: "cliente_big", locals: {cliente: direzione})  + content_tag(:div, nested_scuole(plessi), :class => "nested_scuole")
    end.join.html_safe
  end


  def next_visita_div(cliente)
    content_tag :div, :class => 'next-visita pull-right' do
      unless cliente.next_visita.empty?
        link_to  giro_path(giorno: cliente.next_visita[0].giorno)do
          content_tag( :span, l(cliente.next_visita[0].start.to_date, format: :day_of_month), class: "label label-info")
        end
      else
        ""
      end
    end
  end


end