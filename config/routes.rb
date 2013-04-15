TodoPropa::Application.routes.draw do
  
  use_doorkeeper

  namespace :api do
    namespace :v1  do
      
      #resources :tokens,  :only => [:create, :destroy]
      resources :appunti, :except => [:new, :edit] do
        resources :righe,    :except => :index
      end
      
      resources :clienti, :only => [:index, :show, :create, :update]
      resources :libri
      resources :righe,    :only => :index
      resources :classi,   :only => [:index, :update]
      resources :adozioni, :only => [:index, :update]
    end
  end


  resources :appunto_events

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
  
  get 'tags/:tag', to: 'appunti#index', as: :tag
  
  match '/vendite', controller: 'magazzino', action: 'vendite'
  match '/cassa',   controller: 'magazzino', action: 'cassa'
  match '/crea_buoni_di_consegna', controller: 'magazzino', action: 'crea_buoni_di_consegna'
  match '/crea_fatture', controller: 'magazzino', action: 'crea_fatture'
  
  get '/baule', to: 'baule#show', as: 'baule'
  match '/baule/rimuovi', controller: 'baule', action: 'destroy'
  match '/baule/update',  controller: 'baule', action: 'update', :via => :put
  
  
  match '/user/profile',  controller: 'user_profile', action: 'edit'
  match '/user/update_profile',  controller: 'user_profile', action: 'update', :via => :put
  
  resources :visita_appunti

  match '/:action.appcache', :controller => 'appcache', :format => :appcache
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
      get  :export
      post :import
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
