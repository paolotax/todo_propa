module ClientiHelper

  def nested_scuole(scuole)
    scuole.map do |direzione, plessi|
      render(partial: "cliente_big", locals: {cliente: direzione})  + content_tag(:div, nested_scuole(plessi), :class => "nested_scuole")
    end.join.html_safe
  end


  def next_visita_div(cliente)
    content_tag :div, :class => 'next-visita pull-right' do
      unless cliente.next_visita.nil?
        link_to  giro_path(giorno: cliente.next_visita.data)do
          content_tag( :span, l(cliente.next_visita.data, format: :day_of_month), class: "label label-info")
        end
      else
        ""
      end
    end
  end


end