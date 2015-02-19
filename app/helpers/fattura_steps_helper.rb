module FatturaStepsHelper
  

  def nested_righe_documenti_per_fattura(righe)
    
    righe.order(:fattura_id).group_by(&:fattura).map do |a, righe|
      content_tag :div, :class => 'dettaglio_fattura' do
        content_tag( :div, check_box_tag("fatture_ids[]", a.id, false, {:class => 'cb-element'}) +
        link_to( "#{a.documento_causale} #{a.numero} del #{l a.data, :format => :only_date} - copie #{a.totale_copie} - Importo #{a.importo_fattura}", fattura_path(a)).html_safe, :class => 'consegna') +
        content_tag( :div, righe.collect{ |r| render r }.join.html_safe, :class => 'table-righe-new')
      end
    end.join.html_safe
  end


end
