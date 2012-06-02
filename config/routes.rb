TodoPropa::Application.routes.draw do
  
  mount WillFilter::Engine => "/will_filter"
  
  resources :materie

  resources :classi

  resources :adozioni
  
  match '/vendite', controller: 'magazzino', action: 'vendite'
  
  match '/baule', controller: 'baule', action: 'show'
  match '/baule/rimuovi', controller: 'baule', action: 'destroy'
  match '/baule/update',  controller: 'baule', action: 'update', :via => :put
  
  resources :visita_appunti

  match '/:action.appcache', :controller => 'appcache', :format => :appcache
  match '/get_appunti_filters', :controller => :search, :action  => :get_appunti_filters, :format => :js
  match '/get_clienti_filters', :controller => :search, :action  => :get_clienti_filters, :format => :js
  
  match '/search/autocomplete', format: :json
  
  resources :visite do
    resources :visita_appunti
  end

  
  resources :comuni

  resources :fatture do
    resources :fattura_steps
  end

  devise_for :users

  resources :appunti do
    collection do
      put :update_attribute_on_the_spot
    end
    member do
      get :get_note
    end
  end
  
  resources :clienti do
    
    resources :indirizzi

    collection do
      put :update_attribute_on_the_spot
    end
  end
  
  resources :indirizzi
  
  resources :righe
  
  resources :libri do
    collection do
      put :update_attribute_on_the_spot
      # get :get_attribute_on_the_spot
    end
  end
  
  root :to => 'appunti#index'

end
