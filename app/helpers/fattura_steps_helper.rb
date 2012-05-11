module FatturaStepsHelper
  
  def nested_righe_per_appunto(righe)
    
    righe.group_by(&:appunto).map do |a, righe|
      content_tag :div, :class => 'dettaglio_fattura' do
        content_tag( :div, check_box_tag("appunti_ids[]", a.id, true, {:class => 'cb-element'}) +
        link_to( "Appunto del #{l a.created_at, :format => :short} - copie #{a.totale_copie} - Importo #{a.totale_importo}", appunto_path(a)).html_safe, :class => 'consegna') +
        content_tag( :table, righe.collect{ |r| render r }.join.html_safe, :class => 'table dettagli')
      end
    end.join.html_safe
  end
  
end
