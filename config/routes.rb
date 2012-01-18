TodoPropa::Application.routes.draw do

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
  
  resources :righe
  
  resources :libri
  
  root :to => 'appunti#index'

end
