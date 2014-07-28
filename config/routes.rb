TodoPropa::Application.routes.draw do
  
  


  use_doorkeeper

  
  resources :propa2014s do
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
      get :pianifica
      get :svuota_baule
    end
  end


  namespace :api do
    namespace :v1  do
      
      #resources :tokens,  :only => [:create, :destroy]
      resources :appunti, :except => [:new, :edit] do
        resources :righe,    :except => :index

        collection do
          put :print_multiple, format: :pdf
        end
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
    member do
      get :aggiungi_sezione
    end
    collection do
      post 'destroy_all'
    end
  end
  
  
  resources :adozioni do
    collection do
      put  'update_multiple'
      post 'destroy_all'
      put  'classifiche'
      put  'scuole'
    end
    collection do
      put 'print_multiple', format: :pdf
    end
  end
  
  
  resources :materie
  
  
  get 'tags/:tag', to: 'appunti#index', as: :tag
  
  
  match '/vendite', controller: 'magazzino', action: 'vendite'
  match '/cassa',   controller: 'magazzino', action: 'cassa'
  match '/incassi', controller: 'magazzino', action: 'incassi'
    
  
  get '/baule', to: 'baule#show', as: 'baule'
  match '/baule/rimuovi', controller: 'baule', action: 'destroy'
  match '/baule/update',  controller: 'baule', action: 'update', :via => :put
  
  
  match '/user/profile',  controller: 'user_profile', action: 'edit'
  match '/user/update_profile',  controller: 'user_profile', action: 'update', :via => :put
  
  
  resources :visita_appunti

  
  match '/:action.appcache', :controller => 'appcache', :format => :appcache
  match '/search/autocomplete', format: :json
  
  
  resources :visite do
    collection { post 'sort'}
    resources :visita_appunti
    collection do
      post 'destroy_all'
    end
  end
  
  
  match "giri"         => "giri#index", as: "giri"
  match "giri/:giorno/print" => "giri#print_multiple",  as: "giro"
  match "giri/:giorno" => "giri#show",  as: "giro"
  
  match "propa2014"         => "clienti#propa2014", as: "propa2014"
  
  
  resources :comuni

  
  resources :fatture do
    resources :fattura_steps
    collection do
      put 'create_multiple'
    end
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

    member do
      get :scorri_classi
      put :registra_documento
      put :sposta_righe
    end
    
    resources :indirizzi

    resources :classi_inserters
    
    collection do
      get  :export
      post :import
      put :update_attribute_on_the_spot
    end
  end
  
  resources :libri_inserters, only: :create

  resources :righe
  
  
  resources :libri do
    collection do
      put :update_attribute_on_the_spot
      # get :get_attribute_on_the_spot
    end
  end
  
  resources :editori

  root :to => 'appunti#index'

end
