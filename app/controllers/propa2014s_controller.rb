class Propa2014sController < ApplicationController
  
  
  def index

    @clienti = current_user.clienti.scuole.filtra(params).per_localita

    @clienti_grouped = @clienti.scuola_primaria.all.group_by(&:parent)

    @direzioni = @clienti_grouped.keys.reject{ |c| c.nil? }.sort_by{|c| [c.provincia, c.comune, c.id] }
    
    @provincie = current_user.clienti.not_deleted.direzioni.select_provincia.map(&:provincia)
        
  end


  def pianifica
    @clienti = current_user.clienti.not_deleted.scuola_primaria.nel_baule

    @clienti.each do |c|
      if params[:data_visita].present?
        if params[:data_visita] == 'no'
          c.propa2014.data_visita = Date.new(2014, 1, 1) 
        elsif params[:data_visita] == "da_fare"
          c.propa2014.data_visita = nil
        else
          c.propa2014.data_visita = Chronic::parse(params[:data_visita])
        end
      elsif params[:data_vacanze].present?
        if params[:data_vacanze] == 'no'
          c.propa2014.data_vacanze = Date.new(2014, 1, 1)  
        elsif params[:data_vacanze] == "da_fare"
          c.propa2014.data_vacanze = nil
        else
          c.propa2014.data_vacanze = Chronic::parse(params[:data_vacanze])
        end
      elsif params[:data_ritiro].present?
        if params[:data_ritiro] == 'no'
          c.propa2014.data_ritiro = Date.new(2014, 1, 1)  
        elsif params[:data_ritiro] == "da_fare"
          c.propa2014.data_ritiro = nil
        else
          c.propa2014.data_ritiro = Chronic::parse(params[:data_ritiro])
        end
      end
      c.propa2014.save
    end
    redirect_to :back
  end


  def svuota_baule
    @visite = current_user.visite.nel_baule
    @visite.each do |v|
      v.destroy
    end
    redirect_to :back
  end

  
  
end
