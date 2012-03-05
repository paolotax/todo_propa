class SearchController < ApplicationController
  
  respond_to :js
  
  def get_appunti_filters
    
    # @search = current_user.appunti.includes(:cliente, :user, :righe => :libro).filtra(params)
    # @appunti = @search.recente.limit(20)
    # @appunti = @appunti.offset((params[:page].to_i-1)*20) if params[:page].present?

    @provincie = current_user.clienti.select_provincia.filtra(params.except(:provincia).except(:comune)).order(:provincia)
    @citta     = current_user.clienti.select_citta.filtra(params.except(:comune)).order(:comune)
  end

end