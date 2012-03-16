class SearchController < ApplicationController
  
  respond_to :js
  
  def get_appunti_filters
    
    @search = current_user.appunti.filtra(params.except(:status))
    
    @in_corso = @search.in_corso.size
    @da_fare  = @search.da_fare.size
    @in_sospeso = @search.in_sospeso.size    
    @tutti = @search.size 
    
    @provincie = current_user.clienti.select_provincia.filtra(params.except(:provincia).except(:comune)).order(:provincia)
    @citta     = current_user.clienti.select_citta.filtra(params.except(:comune)).order(:comune)
  end
  
  def get_clienti_filters
    
    @search = current_user.appunti.filtra(params.except(:status))
    
    @in_corso   = Cliente.con_appunto(@search.in_corso).size
    @da_fare    = Cliente.con_appunto(@search.da_fare).size
    @in_sospeso = Cliente.con_appunto(@search.in_sospeso).size    
    @tutti      = Cliente.con_appunto(@search).size 
    
    @provincie = current_user.clienti.select_provincia.filtra(params.except(:provincia).except(:comune)).order(:provincia)
    @citta     = current_user.clienti.select_citta.filtra(params.except(:comune)).order(:comune)
  end

end