module FatturaStepsHelper
  
  def nested_righe_per_appunto(righe)
    
    righe.order(:appunto_id).group_by(&:appunto).map do |a, righe|
      content_tag :div, :class => 'dettaglio_fattura' do
        content_tag( :div, check_box_tag("appunti_ids[]", a.id, true, {:class => 'cb-element'}) +
        link_to( " ##{a.id} del #{l a.created_at, :format => :only_date} #{a.status} - copie #{a.totale_copie} - Importo #{a.totale_importo}", appunto_path(a)).html_safe, :class => 'consegna') +
        content_tag( :div, righe.collect{ |r| render r }.join.html_safe, :class => 'table-righe-new')
      end
    end.join.html_safe
  end
  
end
