TodoPropa::Application.routes.draw do

  get "visita_righe/index"

  get "visita_righe/create"

  get "visita_righe/update"

  get "visita_righe/destroy"

  get "visite/index"

  get "visite/create"

  get "visite/update"

  get "visite/destroy"

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
  
  resources :libri
  
  root :to => 'appunti#index'

end
