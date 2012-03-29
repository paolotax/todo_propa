TodoPropa::Application.routes.draw do

  resources :visita_appunti

  match '/:action.appcache', :controller => 'appcache', :format => :appcache
  match '/get_appunti_filters', :controller => :search, :action  => :get_appunti_filters, :format => :js
  match '/get_clienti_filters', :controller => :search, :action  => :get_clienti_filters, :format => :js
  
  resources :visite do
    resources :visita_appunti
  end

  
  resources :comuni

  resources :fatture

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
