TodoPropa::Application.routes.draw do
  
  mount WillFilter::Engine => "/will_filter"
  
  resources :classi do
    collection do
      post 'destroy_all'
    end
  end
  
  resources :adozioni do
    collection do
      post 'destroy_all'
    end
  end
  
  resources :materie
  
  get 'tags/:tag', to: 'appunti#index', as: :tag, format: :json
  
  match '/vendite', controller: 'magazzino', action: 'vendite'
  match '/cassa',   controller: 'magazzino', action: 'cassa'
  match '/crea_buoni_di_consegna', controller: 'magazzino', action: 'crea_buoni_di_consegna'
  match '/crea_fatture', controller: 'magazzino', action: 'crea_fatture'
  
  match '/baule', controller: 'baule', action: 'show'
  match '/baule/rimuovi', controller: 'baule', action: 'destroy'
  match '/baule/update',  controller: 'baule', action: 'update', :via => :put
  
  
  match '/user/profile',  controller: 'user_profile', action: 'edit'
  match '/user/update_profile',  controller: 'user_profile', action: 'update', :via => :put
  
  resources :visita_appunti

  match '/:action.appcache', :controller => 'appcache', :format => :appcache
  match '/get_appunti_filters', :controller => :search, :action  => :get_appunti_filters, :format => :js
  match '/get_clienti_filters', :controller => :search, :action  => :get_clienti_filters, :format => :js
  
  match '/search/autocomplete', format: :json
  
  resources :visite do
    resources :visita_appunti
    collection do
      post 'destroy_all'
    end
  end
  
  
  match "giri"         => "giri#index", as: "giri"
  match "giri/:giorno" => "giri#show",  as: "giro"
  
  
  
  resources :comuni

  resources :fatture do
    resources :fattura_steps
  end

  devise_for :users

  resources :appunti do
    collection do
      put :update_attribute_on_the_spot
      put :print_multiple, format: :pdf
    end
    member do
      get :get_note
    end
  end
  
  resources :clienti do
    
    resources :indirizzi

    resources :classi_inserters
    
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
