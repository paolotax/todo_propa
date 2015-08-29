class SearchController < ApplicationController
  
  respond_to :json, :js
  
  def autocomplete
    render :json => {
                      "term" => params['term'],
                      "results" => {
                                     "cliente" => Cliente.search_mate(params['term'], current_user.id),
                                     "libro"   => Libro.search_mate(params['term']),
                                     "appunto" => Appunto.search_mate(params['term'], current_user.id)
                                   } 
                    }.to_json, :callback => params[:callback]
  end

end