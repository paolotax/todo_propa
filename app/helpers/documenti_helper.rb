module DocumentiHelper

  def documento_tree_key(documento_ids)

    documenti = current_user.documenti.find(documento_ids)

  end  

  
  def nested_righe_del_documento(parent_documento)
    content_tag(:div, class: "table-righe-new") do
      parent_documento.righe.group_by{ |r| r.previous_documento(parent_documento) }.map do |key, righe|
        (unless key.nil?
          content_tag(:div, class: "rif-appunto") do
            link_to("#{key.documento_causale} nr #{key.numero} del #{l key.data, format: :only_date}", key)
          end          
        else
          content_tag(:div, "", class: "rif-appunto")
        end) +
        content_tag( :div, righe.collect{ |r| render r }.join.html_safe)
      end.join.html_safe
    end
  end


  def nested_righe_del_documento_old(documento)

    documento.righe.group_by{ |r| r.documenti.map(&:id) }.map do |key, righe|     
        documenti = documento_tree_key(key - [documento.id])
        if documenti && !documenti.empty?
          documenti.map do |documento|
            content_tag(:div, class: "dettaglio_documento") do

              link_to("#{documento.documento_causale} nr #{documento.numero} del #{l documento.data, format: :only_date}", documento)

            end
          end.join.html_safe + 
          
          content_tag( :div, righe.collect{ |r| render r }.join.html_safe, :class => 'table-righe-new')
        else
          content_tag( :div, righe.collect{ |r| render r }.join.html_safe, :class => 'table-righe-new')
        end
    end.join.html_safe
  end


  def nested_righe_documenti_per_documento(righe)
    
    righe.group_by(&:state_documento).map do |a, righe|
      content_tag :div, :class => 'dettaglio_documento' do
        content_tag( :div, check_box_tag("documenti_ids[]", a.id, false, {:class => 'cb-toggle'}) +
        link_to( "#{a.documento_causale} #{a.numero} del #{l a.data, :format => :only_date} - copie #{a.totale_copie} - Importo #{a.totale_importo}", documento_path(a)).html_safe, :class => 'consegna') +
        content_tag( :div, righe.sort_by(&:id).collect{ |r| render r }.join.html_safe, :class => 'table-righe-new')
      end
    end.join.html_safe
  end

end
